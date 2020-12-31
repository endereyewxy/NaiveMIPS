`timescale 1ns / 1ps
`include "defines.vh"

module pc(
    input  logic         clk        ,
    input  logic         rst        ,
    input  logic         stall      ,
    input  logic         except     ,
    input  logic `W_ADDR except_addr,
    input  logic         branch     ,
    input  logic `W_ADDR branch_addr, 
    output logic         pc         ,
    output logic `W_ADDR pc_addr    );
    
    logic `W_ADDR pc_real;
    
    assign pc      = ~(rst | stall);
    assign pc_addr = except ? except_addr : pc_real;
    
    always @(posedge clk)begin
        if (rst) begin
            pc_real <= 32'hbfc00000;
        end else if (except) begin
            pc_real <= except_addr + 4;
        end else if (stall) begin
            pc_real <= pc_real;
        end else if (branch) begin
            pc_real <= branch_addr;
        end else begin
            pc_real <= pc_real + 32'h4;
        end
    end
    
endmodule

