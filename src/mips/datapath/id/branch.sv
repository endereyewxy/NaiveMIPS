`timescale 1ns/1ps
`include "defines.vh"

module branch(
    input  logic `W_OPER oper       ,
    input  logic `W_DATA imme       ,
    input  logic `W_DATA source_a   ,
    input  logic `W_DATA source_b   ,
    input  logic `W_ADDR pc         ,
    output logic         branch     ,
    output logic `W_ADDR branch_addr);
    
    logic `W_ADDR rpc;
    logic `W_ADDR off;
    
    assign rpc = pc + 4;
    assign off = {imme[29:0], 2'b00};
    
    assign {branch, branch_addr} =
        (oper == `OPER_J ) ? {1'b1, rpc[31:28], imme[27:2], 2'b00} :
        (oper == `OPER_JR) ? {1'b1, source_a}                      :
        
        (oper == `OPER_BEQ & source_a == source_b) ? {1'b1, rpc + off} :
        (oper == `OPER_BNE & source_a != source_b) ? {1'b1, rpc + off} :
        
        (oper == `OPER_BGEZ & ~source_a[31]) ? {1'b1, rpc + off} :
        (oper == `OPER_BLTZ &  source_a[31]) ? {1'b1, rpc + off} :
        
        (oper == `OPER_BGTZ & (~source_a[31] & source_a != 0)) ? {1'b1, rpc + off} :
        (oper == `OPER_BLEZ & ( source_a[31] | source_a == 0)) ? {1'b1, rpc + off} : 0;
    
endmodule

