`timescale 1ns/1ps
`include "defines.vh"

module regsrc(
    input       logic `W_OPER oper        ,
    input       logic [1:0]   word_offset ,
    input       logic `W_REGF rd_regf     ,
    input       logic `W_DATA rd_data_a   ,
    input       logic `W_DATA rd_data_b   ,
    input       logic `W_ADDR pc          ,
    regf_w.master             rd          );
    
    logic `W_DATA mem_data;
    
    assign mem_data  =
        (word_offset == 2'b00) ?         rd_data_b         :
        (word_offset == 2'b01) ? { 8'h0, rd_data_b[31:8 ]} :
        (word_offset == 2'b10) ? {16'h0, rd_data_b[31:16]} :
                                 {24'h0, rd_data_b[31:24]} ;
    
    assign rd.data = `IS_OPER_JB(oper) ? pc + 8                                                :
                     `IS_OPER_MM(oper) ? (
                        (oper == `OPER_LB ) ? {{24{mem_data[7 ]}}, mem_data[7 :0]} :
                        (oper == `OPER_LBU) ? {24'h0             , mem_data[7 :0]} :
                        (oper == `OPER_LH ) ? {{16{mem_data[15]}}, mem_data[15:0]} :
                        (oper == `OPER_LHU) ? {16'h0             , mem_data[15:0]} : mem_data) : rd_data_a;
    assign rd.regf = `IS_OPER_C0(oper) ? 0                                                     : rd_regf  ;
    
endmodule

