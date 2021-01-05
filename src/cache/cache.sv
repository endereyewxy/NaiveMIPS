`timescale 1ns/1ps

import includes::*;

module cache(
    input      logic         clk       ,
    input      logic         rst       ,
    
    input      logic         cpu_en    ,
    input      logic         cpu_we    ,
    input      logic `W_ADDR cpu_addr  ,
    input      logic [3:0]   cpu_mask_w,
    input      logic `W_DATA cpu_data_w,
    output     logic `W_DATA cpu_data_r,
    input      logic         cpu_pause ,
    output     logic         cpu_stall ,
    
    output     logic         mem_en    ,
    output     logic         mem_we    ,
    output     logic [1:0]   mem_size  ,
    output     logic `W_ADDR mem_addr  ,
    output     logic `W_DATA mem_data_w,
    input      logic `W_DATA mem_data_r,
    input      logic         mem_addr_o,
    input      logic         mem_data_o);
    
    logic `W_CTAG cpu_addr_tag;
    logic `W_CIDX cpu_addr_idx;
    logic `W_COFF cpu_addr_off;
    
    assign {cpu_addr_tag, cpu_addr_idx, cpu_addr_off} = cpu_addr;
    
    logic         now_en      ;
    logic         now_we      ;
    logic `W_CTAG now_addr_tag;
    logic `W_CIDX now_addr_idx;
    logic `W_COFF now_addr_off;
    logic [3:0]   now_mask    ;
    logic `W_DATA now_data    ;
    
    always @(posedge clk) begin
        if (rst)
            {now_en, now_we, now_addr_tag, now_addr_idx, now_addr_off, now_mask, now_data} <= 0;
        else if (~cpu_pause & ~cpu_stall)
            {now_en, now_we, now_addr_tag, now_addr_idx, now_addr_off, now_mask, now_data} <= {cpu_en, cpu_we, cpu_addr, cpu_mask_w, cpu_data_w};
    end
    
    logic hit;
    logic drt;
    
    logic `W_CTAG cur_ctag;
    logic `W_DATA cur_data;
    
    logic [1:0] state;
    
    localparam IDLE = 2'b00;
    localparam WMEM = 2'b01;
    localparam READ = 2'b10;
    
    always @(posedge clk) begin
        if (rst)
            {state, mem_en} <= {IDLE, 1'b0};
        else
            case (state)
                IDLE:
                    if (now_en & ~cpu_pause) begin
                        if (~hit &  drt)
                            {state, mem_en} <= {WMEM, 1'b1};
                        if (~hit & ~drt & (~now_we | now_mask != 4'hf))
                            {state, mem_en} <= {READ, 1'b1};
                    end
                WMEM:
                    begin
                        if (mem_addr_o)
                            mem_en <= 1'b0;
                        if (mem_data_o) begin
                            mem_en <= ~now_we;
                            state  <=  now_we ? IDLE : READ;
                        end
                    end
                READ:
                    begin
                        if (mem_addr_o)
                            mem_en <= 1'b0;
                        if (mem_data_o)
                            state  <= IDLE;
                    end
            endcase
    end
    
    assign mem_we     = state == WMEM;
    assign mem_size   = 2'b10;
    assign mem_addr   = {mem_we ? cur_ctag : now_addr_tag, now_addr_idx, 2'b00};
    assign mem_data_w = cur_data;
    
    assign cpu_data_r = cur_data;
    
    assign cpu_stall = state != IDLE | (now_en & ~hit & (~now_we | now_mask != 4'hf | drt));
    
    logic ram_we;
    logic ram_st;
    
    assign ram_we = state == IDLE ? (now_en & now_we) : mem_data_o;
    assign ram_st = cpu_stall | cpu_pause;
    
    logic `W_CDEP valid;
    logic `W_CDEP dirty;
    
    always @(posedge clk) begin
        if (rst) begin
            valid <= 0;
            dirty <= 0;
        end else if (ram_we) begin
            valid[now_addr_idx] <= 1'b1;
            dirty[now_addr_idx] <= state == IDLE;
        end
    end
    
    assign hit = valid[now_addr_idx] & (cur_ctag == now_addr_tag);
    assign drt = dirty[now_addr_idx];
    
    cache_ram_ctag ram_ctag(
        .clka(~clk),
        .clkb(clk),
        
        .addra(now_addr_idx),
        .wea  (ram_we      ),
        .dina (now_addr_tag),
        
        .addrb(ram_st ? now_addr_idx : cpu_addr_idx),
        .doutb(cur_ctag                            ));
    
    cache_ram_data ram_data(
        .clka(~clk),
        .clkb(clk),
        
        .addra(now_addr_idx                                   ),
        .wea  ((state == READ ? 4'hf : now_mask) & {4{ram_we}}),
        .dina ( state == READ ? mem_data_r : now_data         ),
        
        .addrb(ram_st ? now_addr_idx : cpu_addr_idx),
        .doutb(cur_data                            ));
    
endmodule

