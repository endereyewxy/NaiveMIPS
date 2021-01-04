`timescale 1ns/1ps

import includes::*;

module sglalu(
    input  logic `W_OPER oper         ,
    input  logic `W_FUNC func         ,
    input  logic `W_DATA cp0_rt_data  ,
    output logic         cp0_rd_we    ,
    output logic `W_DATA cp0_rd_data  ,
    input  logic `W_DATA source_a     ,
    input  logic `W_DATA source_b     ,
    output logic `W_DATA result       ,
    output logic         mulalu_sign  ,
    output logic `W_FUNC mulalu_func  ,
    input  logic `W_DATA hi           ,
    output logic         hi_write     ,
    input  logic `W_DATA lo           ,
    output logic         lo_write     ,
    output logic         ov          );
    
    logic `W_DATA add_result;
    logic `W_DATA sub_result;
    logic `W_DATA slt_result;

    assign add_result      = source_a + source_b;
    assign sub_result      = source_a - source_b;
    
    // 这里slt_result表示的是有符号情况下
    assign slt_result    = ( source_a[31] & ~source_b[31]) ? {31'b0, 1'b1}                                   :
                           ( source_a[31] &  source_b[31]) ? ((source_a < source_b) ? {31'b0, 1'b1} : 32'b0) :
                           (~source_a[31] &  source_b[31]) ? 32'b0                                           :
                           ( source_a     <  source_b    ) ? {31'b0, 1'b1}                                   : 32'b0;
    
    assign cp0_rd_we     = oper == `OPER_MTC0;
    
    assign cp0_rd_data   =  source_b;
    
    assign mulalu_func   =  (func == `FUNC_MUL | func == `FUNC_DIV) ? func : 5'b00000;
    
    assign mulalu_sign   =  (mulalu_func == 5'b00000) ? 1'b0 :
                            (oper == `OPER_ALUU)      ? 1'b0 : 1'b1;
    
    assign hi_write      =  (oper == `OPER_MTHI) ? 1'b1 : 1'b0;
    
    assign lo_write      =  (oper == `OPER_MTLO) ? 1'b1 : 1'b0;
    
    function `W_DATA get_result(input logic `W_FUNC func,  input logic `W_DATA source_a, input logic `W_DATA source_b, input logic [4:0] shift);
        case (func)
            `FUNC_OR  : get_result =  (source_a | source_b)                                           ;
            `FUNC_XOR : get_result =  (source_a ^ source_b)                                           ;
            `FUNC_NOR : get_result = ~(source_a | source_b)                                           ;
            `FUNC_LUI : get_result =  ({source_b[15:0], 16'h0})                                       ; 
            `FUNC_SLL : get_result =  (source_a << shift)                                             ;
            `FUNC_SRL : get_result =  (source_a >> shift)                                             ;
            `FUNC_SRA : get_result =  (({32{source_a[31]}} << (32'd32 - shift)) | (source_a >> shift));
            `FUNC_ADD : get_result =  (source_a + source_b)                                           ;
            `FUNC_SUB : get_result =  (source_a - source_b)                                           ;
            default   : get_result =  0                                                               ;
        endcase
    endfunction

    assign result = (func == `FUNC_AND ) ?
                                   ((oper == `OPER_MFHI) ? hi           : 
                                    (oper == `OPER_MFLO) ? lo           : 
                                    (oper == `OPER_MFC0) ? cp0_rt_data  : (source_a & source_b))                          :
                    (func == `FUNC_SLT ) ?
                                   ((oper == `OPER_ALUS) ? (slt_result) : ((source_a < source_b) ? {31'h0,1'b1} : 32'h0)) :
                    get_result(func, source_a, source_b, source_b[4:0]);
    
    assign ov = (func == `FUNC_ADD & oper == `OPER_ALUS) ?
                  (((~source_a[31] & ~source_b[31] & add_result[31]) | (source_a[31] &  source_b[31] & ~add_result[31])) ? 1'b1 : 1'b0) :
                (func == `FUNC_SUB & oper == `OPER_ALUS) ?
                  (((~source_a[31] &  source_b[31] & sub_result[31]) | (source_a[31] & ~source_b[31] & ~sub_result[31])) ? 1'b1 : 1'b0) : 1'b0;
    
endmodule

