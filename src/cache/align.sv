`timescale 1ns/1ps

import includes::*;

module align(
    input  logic `W_COFF coff_i,
    input  logic [1:0]   size_i,
    input  logic `W_DATA data_i,
    input  logic `W_DATA data_f,
    
    output logic `W_DATA data_a,
    output logic `W_DATA data_s);
    
    assign data_a = size_i == 2'b00 ? (coff_i == 2'b00 ? {data_f[31: 8], data_i[ 7:0]              }  :
                                       coff_i == 2'b01 ? {data_f[31:16], data_i[ 7:0], data_f[ 7:0]}  :
                                       coff_i == 2'b10 ? {data_f[31:24], data_i[ 7:0], data_f[15:0]}  :
                                                         {               data_i[ 7:0], data_f[23:0]}) :
                    size_i == 2'b01 ? (coff_i == 2'b00 ? {data_f[31:16], data_i[15:0]              }  :
                                                         {               data_i[15:0], data_f[15:0]}) :
                                                                         data_i                       ;
    
    assign data_s = coff_i == 2'b00 ?         data_i         :
                    coff_i == 2'b01 ? { 8'h0, data_i[31: 8]} :
                    coff_i == 2'b10 ? {16'h0, data_i[31:16]} :
                                      {24'h0, data_i[31:24]} ;
    
endmodule

