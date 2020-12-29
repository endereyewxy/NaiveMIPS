`timescale 1ns / 1ps
module wb(
    input  logic `W_OPER oper        ,
    input  logic `W_REGF rd_regf     ,
    input  logic `W_DATA rd_data_a   ,
    input  logic `W_DATA rd_data_b   ,
    output logic `W_DATA rd_data     ,
    output logic `W_REGF rd_regf_out);

    regsrc regsrc_(oper, rd_regf, rd_data_a, rd_data_b, rd_data, rd_regf_out);

endmodule
