`timescale 1ns/1ps

import includes::*;

module sbus_to_sram_like(
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
    
    assign sram_like_wr   = sbus_we  ;
    assign sram_like_size = sbus_size;
    assign sram_like_addr = sbus_addr;
    
    assign sram_like_wdata = (sbus_addr[1:0] == 2'b11) ? {sbus_data_w[23:0], 24'h0} :
                             (sbus_addr[1:0] == 2'b10) ? {sbus_data_w[15:0], 16'h0} :
                             (sbus_addr[1:0] == 2'b01) ? {sbus_data_w[ 7:0],  8'h0} :
                                                          sbus_data_w               ;
    
    // 处理请求时序
    
    logic req;
    
    always @(posedge clk)
        if (rst | sram_like_addr_ok) req <= 1'b0; else if (sbus_en) req <= 1'b1;
    
    assign sram_like_req = sbus_en | req;
    
    // 处理读时序，需要滞后一个周期
    
    logic `W_DATA data_r;
    assign        data_r = sbus_addr[1:0] == 2'b00 ?         sram_like_rdata         :
                           sbus_addr[1:0] == 2'b01 ? { 8'h0, sram_like_rdata[31: 8]} :
                           sbus_addr[1:0] == 2'b10 ? {16'h0, sram_like_rdata[31:16]} :
                                                     {24'h0, sram_like_rdata[31:24]} ;
    
    logic `W_DATA data_saved;
    logic `W_DATA data_ready;
    
    always @(posedge clk) begin
        data_saved <= rst ? 32'h0 :  sram_like_data_ok ? data_r : data_saved;
        data_ready <= sbus_update ? (sram_like_data_ok ? data_r : data_saved) : data_ready;
    end
    
    assign sbus_data_r = data_ready;
    
    // 状态机逻辑
    
    logic state; // 是否就绪
    
    always @(posedge clk) begin
        if (rst)
            state <= 1'b1;
        else
            state <= sbus_en ? 1'b0 : sram_like_data_ok ? 1'b1 : state;
    end
    
    // 停顿逻辑
    
    assign sbus_stall = state ? sbus_en : ~sram_like_data_ok;
    
endmodule

