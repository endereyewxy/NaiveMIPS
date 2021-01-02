`timescale 1ns/1ps

import includes::*;

module cache(
    input      logic         clk              ,
    input      logic         rst              ,
    
    input      logic         sbus_update      ,
    input      logic         sbus_en          ,
    input      logic         sbus_we          ,
    input      logic [1:0]   sbus_size        ,
    input      logic `W_ADDR sbus_addr        ,
    input      logic `W_DATA sbus_data_w      ,
    output     logic `W_DATA sbus_data_r      ,
    output     logic         sbus_stall       ,
    
    output     logic         sram_like_req    ,
    output     logic         sram_like_wr     ,
    output     logic [1:0]   sram_like_size   ,
    output     logic `W_ADDR sram_like_addr   ,
    output     logic `W_DATA sram_like_wdata  ,
    input      logic `W_DATA sram_like_rdata  ,
    input      logic         sram_like_addr_ok,
    input      logic         sram_like_data_ok);
    
    // 拆分地址
    
    logic `W_CTAG addr_tag;
    logic `W_CIDX addr_idx;
    logic `W_COFF addr_off;
    
    assign {addr_tag, addr_idx, addr_off} = sbus_addr;
    
    // 实例化缓存组
    
    logic set_we;
    logic set_wp;
    logic set_wd;
    
    logic `W_DATA set_data_w;
    
    logic         set_hit     [`CACHE_DEPTH - 1 : 0];
    logic         set_h_valid [`CACHE_DEPTH - 1 : 0];
    logic `W_DATA set_h_data  [`CACHE_DEPTH - 1 : 0];
    logic         set_r_dirty [`CACHE_DEPTH - 1 : 0];
    logic `W_CTAG set_r_ctag  [`CACHE_DEPTH - 1 : 0];
    logic `W_DATA set_r_data  [`CACHE_DEPTH - 1 : 0];
    
    logic         hit    ;
    logic         h_valid;
    logic `W_DATA h_data ;
    logic         r_dirty;
    logic `W_CTAG r_ctag ;
    logic `W_DATA r_data ;
    
    assign hit     = set_hit    [addr_idx];
    assign h_valid = set_h_valid[addr_idx];
    assign r_dirty = set_r_dirty[addr_idx];
    assign r_ctag  = set_r_ctag [addr_idx];
    assign r_data  = set_r_data [addr_idx];
    
    generate
        for (genvar i = 0; i < `CACHE_DEPTH; i = i + 1) begin : generate_cacheset
            
            logic  ena;
            assign ena = addr_idx == i;
            
            cacheset cacheset_(
                .clk    (clk           ),
                .rst    (rst           ),
                .rd     (ena           ),
                .we     (ena & set_we  ),
                .wp     (ena & set_wp  ),
                .wd     (ena & set_wd  ),
                .ctag_w (addr_tag      ),
                .data_w (set_data_w    ),
                .ctag   (addr_tag      ),
                .hit    (set_hit    [i]),
                .h_valid(set_h_valid[i]),
                .h_data (set_h_data [i]),
                .r_dirty(set_r_dirty[i]),
                .r_ctag (set_r_ctag [i]),
                .r_data (set_r_data [i]));
        end
    endgenerate
    
    // 其它准备工作
    
    logic [3:0] mask;
    assign      mask = sbus_size == 2'b00 ? (sbus_addr[1:0] == 2'b00 ? 4'b0001 :
                                             sbus_addr[1:0] == 2'b01 ? 4'b0010 :
                                             sbus_addr[1:0] == 2'b10 ? 4'b0100 :
                                                                       4'b1000 ) :
                       sbus_size == 2'b01 ? (sbus_addr[1:0] == 2'b00 ? 4'b0011 :
                                                                       4'b1100 ) :
                                                                       4'b1111   ;
    
    logic  need_wb;
    assign need_wb = ~hit & r_dirty;
    logic  need_rd;
    assign need_rd = ~hit & ~sbus_we;
    
    // 状态机逻辑
    
    localparam OK = 2'b00; // 就绪
    localparam WR = 2'b01; // 写回
    localparam RD = 2'b10; // 替换
    
    logic [2:0] state;
    
    always @(posedge clk) begin
        if (rst) begin
            state <= OK;
        end else begin
            case (state)
                OK: state <= sbus_en & need_wb ? WR :
                             sbus_en & need_rd ? RD : OK;
                
                WR: state <= sram_like_data_ok ? (need_rd ? RD : OK) : WR;
                
                RD: state <= sram_like_data_ok ? OK : RD;
            endcase
        end
    end
    
    assign h_data = (state == RD & sram_like_data_ok) ? sram_like_rdata : set_h_data[addr_idx];
    
    // 处理缓存组的写逻辑
    
    logic  we_mem;
    assign we_mem =  state == RD & sram_like_data_ok;                       // 从内存中加载数据
    logic  we_dir;
    assign we_dir =  state == OK & sbus_en & sbus_we & hit;                 // 直接写命中
    logic  we_new;
    assign we_new = (state == OK & sbus_en & sbus_we & ~hit & ~r_dirty  ) | // 未命中但无需写回
                    (state == WR &           sbus_we & sram_like_data_ok) ; // 未命中，写回完成之后
    
    assign set_we = we_mem | we_dir | we_new;
    assign set_wp = we_mem | we_new;
    assign set_wd = we_dir | we_new;
    
    assign set_data_w = ~set_wd ? sram_like_rdata : sbus_size == 2'b00 ? (sbus_addr[1:0] == 2'b00 ? {h_data[31: 8], sbus_data_w[ 7:0]              }  :
                                                                          sbus_addr[1:0] == 2'b01 ? {h_data[31:16], sbus_data_w[ 7:0], h_data[ 7:0]}  :
                                                                          sbus_addr[1:0] == 2'b10 ? {h_data[31:24], sbus_data_w[ 7:0], h_data[15:0]}  :
                                                                                                    {               sbus_data_w[ 7:0], h_data[23:0]}) :
                                                    sbus_size == 2'b01 ? (sbus_addr[1:0] == 2'b00 ? {h_data[31:16], sbus_data_w[15:0]              }  :
                                                                                                    {               sbus_data_w[15:0], h_data[15:0]}) :
                                                                                                                    sbus_data_w                       ;
    
    // 处理请求时序
    
    logic  req_posedge;
    assign req_posedge = (state == OK & sbus_en           & (need_wb | need_rd)) | // OK -> WR | OK -> RD
                         (state == WR & sram_like_data_ok &            need_rd ) ; // WR -> RD
    
    logic req;
    
    always @(posedge clk)
        if (rst | sram_like_addr_ok) req <= 1'b0; else if (req_posedge) req <= 1'b1;
    
    assign sram_like_req = req_posedge | req;
    
    // 连接总线接口
    
    assign sram_like_wr    = need_wb;
    assign sram_like_size  = 2'b10;
    assign sram_like_addr  = need_wb ? {r_ctag, addr_idx, 2'b00} : {sbus_addr[31:2], 2'b00};
    assign sram_like_wdata = r_data;
    
    logic `W_DATA sbus_data;
    logic `W_DATA last_data;
    
    // 处理读时序，需要滞后一个周期
    
    logic `W_DATA data_r;
    assign        data_r = sbus_addr[1:0] == 2'b00 ?         h_data         :
                           sbus_addr[1:0] == 2'b01 ? { 8'h0, h_data[31: 8]} :
                           sbus_addr[1:0] == 2'b10 ? {16'h0, h_data[31:16]} :
                                                     {24'h0, h_data[31:24]} ;
    
    logic  data_update;
    assign data_update = (state == OK & sbus_en & ~sbus_we & hit) | // 直接读
                         (state == RD & sram_like_data_ok       ) ; // 已经替换完成
    
    logic `W_DATA data_saved;
    logic `W_DATA data_ready;
    
    always @(posedge clk) begin
        data_saved <= rst ? 32'h0 :  data_update ? data_r : data_saved;
        data_ready <= sbus_update ? (data_update ? data_r : data_saved) : data_ready;
    end
    
    assign sbus_data_r = data_ready;
    
    // 处理停顿逻辑
    
    assign sbus_stall = (state == OK & sbus_en & (need_wb | need_rd)) | // 需要写回或者替换
                        (state == WR                                ) | // 正在写回
                        (state == RD &           ~sram_like_data_ok ) ; // 还没有替换完成
    
endmodule

