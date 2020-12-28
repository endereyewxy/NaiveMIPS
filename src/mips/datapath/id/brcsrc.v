`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/28 22:34:05
// Design Name: 
// Module Name: brcsrc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.vh"

module brcsrc(
    input  wire forward_rs,
    input  wire forward_rd,
    input  wire `W_DATA forward_rs_dara,
    input  wire `W_DATA forward_rd_dara,
    input  wire `W_DATA rs_dara,
    input  wire `W_DATA rt_dara,
    output wire `W_DATA source_a,
    output wire `W_DATA source_b
    );
    
    assign source_a = (forward_rs == 1) ? forward_rs_dara : rs_dara;
    assign source_b = (forward_rd == 1) ? forward_rd_dara : rd_dara;

endmodule
