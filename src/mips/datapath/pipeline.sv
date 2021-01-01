`timescale 1ns/1ps

module pipeline #(parameter W = 32) (
    input  logic           clk   ,
    input  logic           rst   ,
    input  logic           stall ,
    input  logic           flush ,
    input  logic [W - 1:0] data_i,
    output logic [W - 1:0] data_o);
    
    always @(posedge clk) begin
        if (rst | flush)
            data_o <= 0;
        else if (~stall)
            data_o <= data_i;
    end
    
endmodule

