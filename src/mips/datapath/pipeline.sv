`timescale 1ns/1ps
`include "defines.vh"

module pipeline #(parameter type T = logic `W_DATA) (
    input  logic clk   ,
    input  logic rst   ,
    input  logic stall ,
    input  logic flush ,
    input  T     data_i,
    output T     data_o);
    
    always @(posedge clk) begin
        if (rst | flush)
            data_o <= 0;
        else if (~stall)
            data_o <= data_i;
    end
    
endmodule

