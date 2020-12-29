`timescale 1ns/1ps
`include "defines.vh"

module branch(
    input  wire `W_OPER oper       ,
    input  wire `W_DATA imme       ,
    input  wire `W_DATA source_a   ,
    input  wire `W_DATA source_b   ,
    input  wire `W_ADDR pc         ,
    output wire         branch     ,
    output wire `W_ADDR branch_addr);
    
    wire `W_ADDR rpc;
    
    assign rpc = pc + 4;
    
    assign {branch, branch_addr} =
        (oper == `OPER_J ) ? {1'b1, rpc[31:28], imme[27:2], 2'b00} :
        (oper == `OPER_JR) ? {1'b1, source_a}                      :
        
        (oper == `OPER_BEQ & source_a == source_b) ? {1'b1, rpc + imme} :
        (oper == `OPER_BNE & source_a != source_b) ? {1'b1, rpc + imme} :
        
        (oper == `OPER_BGEZ & ~source_a[31]) ? {1'b1, rpc + imme} :
        (oper == `OPER_BLTZ &  source_a[31]) ? {1'b1, rpc + imme} :
        
        (oper == `OPER_BGTZ & (~source_a[31] & source_a != 0)) ? {1'b1, rpc + imme} :
        (oper == `OPER_BLEZ & ( source_a[31] | source_a == 0)) ? {1'b1, rpc + imme} : 0;
    
endmodule

