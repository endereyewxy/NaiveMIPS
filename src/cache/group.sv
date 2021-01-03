`timescale 1ns/1ps

import includes::*;

module group(
    input  logic         clk     ,
    input  logic         rst     ,
    
    input  logic `W_ADDR addr    ,
    input  logic [1:0]   size    ,
    
    output logic         hit     ,
    input  logic         rep     ,
    
    input  logic         we      ,
    input  logic         wp      ,
    input  logic         wm      ,
    input  logic         wd      ,
    input  logic `W_DATA data_w  ,
    
    output logic         need_r  ,  // dirty
    output logic `W_CTAG ctag_r  ,
    output logic `W_DATA data_r  ,
    output logic `W_DATA data_s  );
    
    // 分离地址
    
    logic `W_CTAG addr_tag;
    logic `W_CIDX addr_idx;
    logic `W_COFF addr_off;
    assign {addr_tag, addr_idx, addr_off} = addr;
    
    // 生成按字对齐之后的，能直接写入 RAM 的数据
    
    logic [3:0]   mask_a;
    logic `W_DATA data_a;
    assign {mask_a, data_a} = size == 2'b00 ? (addr_off == 2'b00 ? {4'b0001, 24'h0, data_w[ 7:0]       }  :
                                               addr_off == 2'b01 ? {4'b0010, 16'h0, data_w[ 7:0],  8'h0}  :
                                               addr_off == 2'b10 ? {4'b0100,  8'h0, data_w[ 7:0], 16'h0}  :
                                                                   {4'b1000,        data_w[ 7:0], 24'h0}) :
                              size == 2'b01 ? (addr_off == 2'b00 ? {4'b0011, 16'h0, data_w[15:0]       }  :
                                                                   {4'b1100,        data_w[15:0], 16'h0}) :
                                                                   {4'b1111,        data_w             }  ;
    
    // 使用寄存器维护有效位和脏位
    
    logic [`CACHE_DEPTH - 1 : 0] valid;
    logic [`CACHE_DEPTH - 1 : 0] dirty;
    
    always @(posedge clk) begin
        if (rst) begin
            valid <= 0;
            dirty <= 0;
        end if (we) begin
            if (wp & rep)
                valid[addr_idx] <= 1'b1;
            if (wp ? rep : hit)
                dirty[addr_idx] <= wd;
        end
    end
    
    // 使用 RAM 维护标签信息和数据块
    
    logic  ctag_we;
    logic  data_we;
    assign ctag_we = we & wp & rep;
    assign data_we = we & (wp ? rep : hit);
    
    cache_ram_ctag cache_ram_ctag_(
        .clka (clk     ),
        .wea  (ctag_we ),
        .addra(addr_idx),
        .dina (addr_tag),
        
        .clkb (~clk    ),
        .enb  (~ctag_we),
        .addrb(addr_idx),
        .doutb(ctag_r  ));
    
    cache_ram_data cache_ram_data_(
        .clka (clk                                ),
        .wea  ({4{data_we}} & (wm ? 4'hf : mask_a)),
        .addra(addr_idx                           ),
        .dina (wm ? data_w : data_a               ),  // 写替换时写整字，写数据时写对齐字
        
        .clkb (~clk    ),
        .enb  (~data_we),
        .addrb(addr_idx),
        .doutb(data_r  ));
    
    // 维护是否命中
    
    always @(*) begin
        if (valid[addr_idx])
            hit = addr_tag == ctag_r;
        else
            hit = 1'b0;
    end
    
    // 维护是否脏
    
    assign need_r = dirty[addr_idx];
    
    // 维护移位之后的，能直接返回给 CPU 的读出数据
    
    assign data_s = addr_off == 2'b00 ?         data_r         :
                    addr_off == 2'b01 ? { 8'h0, data_r[31: 8]} :
                    addr_off == 2'b10 ? {16'h0, data_r[31:16]} :
                                        {24'h0, data_r[31:24]} ;
    
endmodule

