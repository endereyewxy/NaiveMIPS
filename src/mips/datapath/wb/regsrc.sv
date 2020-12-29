`timescale 1ns / 1ps
`include"defines.vh"

module regsrc(
    input  logic `W_OPER oper        ,
    input  logic `W_REGF rd_regf     ,
    input  logic `W_DATA rd_data_a   ,
    input  logic `W_DATA rd_data_b   ,
    output logic `W_DATA rd_data     ,
    output logic `W_REGF rd_regf_out);

    assign rd_data     = `IS_OPER_MM(oper) ? rd_data_b : rd_data_a;
    assign rd_regf_out = rd_regf;
    
endmodule
