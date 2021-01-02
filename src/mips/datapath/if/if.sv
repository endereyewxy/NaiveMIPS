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
    output logic `W_ADDR pc         );
    
    pc pc_(.*);
    
endmodule

