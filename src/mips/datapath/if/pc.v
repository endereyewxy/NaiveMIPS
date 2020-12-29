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

module pc(
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
    always@(posedge clk)begin
        if (rst == 1'b1) begin
            pc <= 1'b0;
        end else begin
            pc <= 1'b1;
        end
    end
    
    always@(posedge clk)begin
        if(pc == 1'b0)begin
            pc_addr <= 32'h00000000;
        end else if(stall == 1'b0)begin
            if(except == 1'b1)begin
                pc_addr <= except_addr;
            end else begin
                if(branch == 1'b1)begin
                    pc_addr <= branch_addr;
                end else begin
                    pc_addr <= pc_addr + 4'h4;
                end
            end
        end
    end
endmodule