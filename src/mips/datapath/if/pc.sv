`timescale 1ns/1ps

import includes::*;

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
    
    
    assign pc = ~(rst | stall);
    
    always @(posedge clk)begin
        if (rst)
            pc_addr <= 32'hbfc00000;
        else if (except)
            pc_addr <= except_addr;
        else if (stall)
            pc_addr <= pc_addr;
        else if (branch)
            pc_addr <= branch_addr;
        else
            pc_addr <= pc_addr + 32'h4;
    end
    
endmodule

