`timescale 1ns/1ps

import includes::*;

module if_(
    input  logic         clk        ,
    input  logic         rst        ,
    input  logic         stall      ,
    input  logic         except     ,
    input  logic `W_ADDR except_addr,
    input  logic         branch     ,
    input  logic `W_ADDR branch_addr, 
    output logic         pc         ,
    output logic `W_ADDR pc_addr    );
    
    pc pc_(clk, rst, stall, except, except_addr, branch, branch_addr, pc, pc_addr);
    
endmodule

