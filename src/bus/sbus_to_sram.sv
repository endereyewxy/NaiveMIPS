`timescale 1ns/1ps

import includes::*;

module sbus_to_sram(
    input      logic         clk       ,
    input      logic         rst       ,
    sbus.slave               sbus      ,
    output     logic         sram_en   ,
    output     logic [3:0]   sram_we   ,
    output     logic `W_ADDR sram_addr ,
    output     logic `W_DATA sram_wdata,
    input      logic `W_DATA sram_rdata);
    
    logic [3:0] mask;
    
    assign mask = (sbus.size == 2'b00) ? (
                      (sbus.addr[1:0] == 2'b00) ? 4'b0001  :
                      (sbus.addr[1:0] == 2'b01) ? 4'b0010  :
                      (sbus.addr[1:0] == 2'b10) ? 4'b0100  :
                                                  4'b1000) :
                  (sbus.size == 2'b01) ? (
                      (sbus.addr[1:0] == 2'b00) ? 4'b0011  :
                      (sbus.addr[1:0] == 2'b10) ? 4'b1100  :
                                                  4'b0000) :
                  (sbus.size == 2'b10) ? (
                      (sbus.addr[1:0] == 2'b00) ? 4'b1111  :
                                                  4'b0000) :
                                                  4'b0000  ;
    
    assign sram_en   =  sbus.en;
    assign sram_we   =  sbus.we ? mask : 0;
    assign sram_addr = {sbus.addr[31:2], 2'b00};
    
    assign sram_wdata = (mask[2:0] == 0) ? {sbus.data_w[ 7:0], 24'h0} :
                        (mask[1:0] == 0) ? {sbus.data_w[15:0], 16'h0} :
                        (mask[  0] == 0) ? {sbus.data_w[23:0],  8'h0} :
                                            sbus.data_w               ;
    
    logic [3:0] read;
    
    always @(posedge clk) begin
        if (rst)
            read <= 0;
        else
            read <= mask;
    end
    
    assign sbus.data_r = (read[2:0] == 0) ? {24'h0, sram_rdata[31:24]} :
                         (read[1:0] == 0) ? {16'h0, sram_rdata[31:16]} :
                         (read[  0] == 0) ? { 8'h0, sram_rdata[31: 8]} :
                                                    sram_rdata         ;
    
    assign sbus.stall = 1'b0;
    
endmodule

