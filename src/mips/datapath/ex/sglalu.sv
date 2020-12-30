`timescale 1ns / 1ps
`include "defines.vh"

module sglalu(
   input  logic `W_OPER oper,
   input  logic `W_FUNC func,
   input  logic `W_DATA cp0_rt_data,
   output logic `W_DATA cp0_rd_data,
   input  logic `W_DATA source_a,
   input  logic `W_DATA source_b,
   output logic `W_DATA result,
   output logic         mulalu_sign,
   output logic `W_FUNC mulalu_func,
   input  logic `W_DATA hi,
   output logic         hi_write,
   output logic `W_DATA hi_write_data,
   input  logic `W_DATA lo,
   output logic         lo_write,
   output logic `W_DATA lo_write_data,
   output logic         ov
    );
          logic `W_DATA add_result;
          logic `W_DATA sub_result;
          logic `W_DATA slt_result;


    assign add_result      = source_a + source_b;
    assign sub_result      = source_a - source_b;
//     这里slt_result表示的是有符号情况下
    assign slt_result      = (source_a[31] & ~source_b[31] & ~((source_a[30:0] == 31'b0) & (source_a == source_b))   ? {31'b0,1'b1}   :
                             (source_a[31] & source_b[31])    ? ((source_a[30:0] > source_b[30:0]) ? {31'b0,1'b1} : 32'b0)            :
                             (~source_a[31] & source_b[31] & ~((source_a[30:0] == 31'b0) & (source_a == source_b)))  ? 32'b0          :
                             (source_a[30:0] < source_b[30:0]) ? {31'b0,1'b1}  : 32'b0;

    assign cp0_rd_data     =  source_a;
    assign mulalu_func     =  (func == `FUNC_MUL | func == `FUNC_DIV) ? func : 5'b00000;
    assign mulalu_sign     =  (mulalu_func == 5'b00000) ? 1'b0 :
                              (oper == `OPER_ALUU)      ? 1'b0 : 1'b1;

    assign hi_write        =  (oper == `OPER_MTHI) ? 1'b1 : 1'b0;
    assign hi_write_data   =  source_a;

    assign lo_write        =  (oper == `OPER_MTLO) ? 1'b1 : 1'b0;
    assign lo_write_data   =  source_a; 

    assign result          =  (func == `FUNC_AND) ? 
                                   ((oper == `OPER_MFHI)  ? hi        : 
                                    (oper == `OPER_MFLO)  ? lo        : (source_a & source_b))                           :
                              (func == `FUNC_OR)  ? (source_a | source_b)                                                :
                              (func == `FUNC_XOR) ? (source_a ^ source_b)                                                :
                              (func == `FUNC_NOR) ? (source_a ^~ source_b)                                               :
                              (func == `FUNC_LUI) ? (source_b)                                                           :
                              (func == `FUNC_SLL) ? (source_a << source_b)                                               :
                              (func == `FUNC_SRL) ? (source_a >> source_b)                                               :
                              (func == `FUNC_SRA) ? (({32{source_a[31]}} << (32'd32 - source_b)) | (source_a >> source_b)) :
                              (func == `FUNC_ADD) ? (add_result)                                                         :
                              (func == `FUNC_SUB) ? (sub_result)                                                         :
                              (func == `FUNC_SLT) ? 
                                    ((oper == `OPER_ALUS)   ? (slt_result) :                            
                                     ((source_a < source_b) ? {31'b0,1'b1} : 32'b0))                                     : cp0_rt_data;
                                                
                              
    assign ov = (func == `FUNC_ADD && oper == `OPER_ALUS) ?
                  (((~source_a[31] && ~source_b[31] && add_result[31]) | (source_a[31] && source_b[31]  && ~add_result[31])) ? 1'b1 : 1'b0) :
                (func == `FUNC_SUB && oper == `OPER_ALUS) ?
                  (((~source_a[31] && source_b[31]  && add_result[31]) | (source_a[31] && ~source_b[31] && ~add_result[31])) ? 1'b1 : 1'b0) : 1'b0;
endmodule
