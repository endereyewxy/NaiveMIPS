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
    output logic `W_ADDR pc         );
    
    logic `W_ADDR reg_pc;
    
    always @(posedge clk)
        reg_pc <= rst    ? 32'hbfc00000 :
                  except ? except_addr  :
                  stall  ? reg_pc       :
                  branch ? branch_addr  : reg_pc + 32'h4;
    
    assign pc = except ? except_addr : reg_pc;
    
endmodule

