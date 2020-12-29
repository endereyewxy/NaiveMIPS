`timescale 1ns / 1ps
`include "defines.vh"

module wb(
    input         logic `W_OPER oper        ,
    input         logic `W_REGF rd_regf     ,
    input         logic `W_DATA rd_data_a   ,
    input         logic `W_DATA rd_data_b   ,
    regf_w.master               rd          );
    
    regsrc regsrc_(.*);
    
endmodule
