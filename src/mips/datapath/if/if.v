`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/28 22:31:33
// Design Name: 
// Module Name: wq1
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

module if_(
    input wire clk,
    input wire rst,
    input wire stall,
    input wire except,
    input wire `W_ADDR except_addr,
    input wire branch,
    input wire `W_ADDR branch_addr, 
    output reg pc,
    output reg `W_ADDR pc_addr
    );
    pc pc_(clk,rst,stall,except,except_addr,branch,branch_addr,pc,pc_addr);
    
endmodule