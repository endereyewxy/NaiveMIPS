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
    
    always @(posedge clk)begin
        if (rst | stall) begin
            pc <= 1'b0;
        end else begin
            pc <= 1'b1;
        end
    end
    
    always @(posedge clk)begin
        if (rst) begin
            pc_addr <= 32'h0;
        end else if (except) begin
            pc_addr <= except_addr;
        end else if (stall) begin
            pc_addr <= pc_addr;
        end else if (branch) begin
            pc_addr <= branch_addr;
        end else begin
            pc_addr <= pc_addr + 32'h4;
        end
    end
    
endmodule
