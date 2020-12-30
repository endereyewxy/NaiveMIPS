`timescale 1ns/1ps
`include "defines.vh"

module regsrc(
    input       logic `W_OPER oper        ,
    input       logic `W_REGF rd_regf     ,
    input       logic `W_DATA rd_data_a   ,
    input       logic `W_DATA rd_data_b   ,
    input       logic `W_ADDR pc          ,
    regf_w.master             rd          );

    assign rd.data = `IS_OPER_JB(oper) ? pc        :
                     `IS_OPER_MM(oper) ? rd_data_b : rd_data_a;
    assign rd.regf = `IS_OPER_C0(oper) ? 0         : rd_regf  ;
    
endmodule

