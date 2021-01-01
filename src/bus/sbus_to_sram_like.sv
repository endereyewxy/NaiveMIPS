`timescale 1ns/1ps

import includes::*;

module sbus_to_sram_like(
    input      logic         clk              ,
    input      logic         rst              ,
    sbus.slave               sbus             ,
    output     logic         sram_like_req    ,
    output     logic         sram_like_wr     ,
    output     logic [1:0]   sram_like_size   ,
    output     logic `W_ADDR sram_like_addr   ,
    output     logic `W_DATA sram_like_wdata  ,
    input      logic `W_DATA sram_like_rdata  ,
    input      logic         sram_like_addr_ok,
    input      logic         sram_like_data_ok);
    
    assign sram_like_wr   = sbus.we  ;
    assign sram_like_size = sbus.size;
    assign sram_like_addr = sbus.addr;
    
    assign sram_like_wdata = (sbus.addr[1:0] == 2'b11) ? {sbus.data_w[23:0], 24'h0} :
                             (sbus.addr[1:0] == 2'b10) ? {sbus.data_w[15:0], 16'h0} :
                             (sbus.addr[1:0] == 2'b01) ? {sbus.data_w[ 7:0],  8'h0} :
                                                          sbus.data_w               ;
    
    logic         last_we    ; // 上一次请求的信息
    logic [1:0]   last_size  ;
    logic `W_DATA last_addr  ;
    logic `W_DATA last_data_w;
    logic `W_DATA last_data_r;
    
    logic  new_req; // 是否产生了新的请求
    assign new_req = sbus.en & ~(sbus.we ? {last_we, last_size, last_addr, last_data_w} === {sbus.we, sbus.size, sbus.addr, sbus.data_w}
                                         : {last_we, last_size, last_addr             } === {sbus.we, sbus.size, sbus.addr             });
    
    assign sbus.data_r = (last_addr[1:0] == 2'b11) ? {24'h0, last_data_r[31:24]} :
                         (last_addr[1:0] == 2'b10) ? {16'h0, last_data_r[31:16]} :
                         (last_addr[1:0] == 2'b01) ? { 8'h0, last_data_r[31: 8]} :
                                                             last_data_r         ;
    
    `define READY 2'b00 // 就绪
    `define WAITA 2'b01 // 等待addr_ok
    `define WAITD 2'b10 // 等待data_ok
    
    logic [1:0] state;
    
    always @(posedge clk) begin
        if (rst) begin
            state       <= `READY;
            last_we     <= 1'b0  ;
            last_size   <= 2'b0  ;
            last_addr   <= 32'h0 ;
            last_data_w <= 32'h0 ;
            last_data_r <= 32'h0 ;
        end else begin
            case (state)
                `READY:
                    if (new_req) begin
                        state       <= `WAITA     ;
                        last_we     <= sbus.we    ;
                        last_size   <= sbus.size  ;
                        last_addr   <= sbus.addr  ;
                        last_data_w <= sbus.data_w;
                    end
                `WAITA:
                    if (sram_like_addr_ok)
                        state <= `WAITD;
                `WAITD:
                    if (sram_like_data_ok) begin
                        state       <= `READY;
                        last_data_r <= sram_like_rdata;
                    end
            endcase
        end
    end
    
    assign sram_like_req = state == `WAITA;
    
    assign sbus.stall = state == `READY ? new_req : ~sram_like_data_ok;
    
endmodule

