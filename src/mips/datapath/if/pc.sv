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
    
    assign pc = ~rst;
    
    logic `W_ADDR reg_addr;
    
    always @(posedge clk)begin
        if (rst)
            reg_addr <= 32'hbfc00000;
        else if (except)
            reg_addr <= except_addr;
        else if (stall)
            reg_addr <= pc_addr;
        else if (branch)
            reg_addr <= branch_addr;
        else
            reg_addr <= pc_addr + 32'h4;
    end
    
    assign pc_addr = except ? except_addr : reg_addr;
    
endmodule

