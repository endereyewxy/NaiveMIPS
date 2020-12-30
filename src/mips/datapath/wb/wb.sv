`timescale 1ns/1ps
`include "defines.vh"

module wb(
    input       logic `W_OPER oper        ,
    input       logic `W_REGF rd_regf     ,
    input       logic `W_DATA rd_data_a   ,
    input       logic `W_DATA rd_data_b   ,
    input       logic `W_ADDR pc          ,
    sram.master               rd          );

    regsrc regsrc_(oper, rd_regf, rd_data_a, rd_data_b, pc, rd);

endmodule

