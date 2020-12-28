`timescale 1ns / 1ps
`include"defines.vh"

module regsrc(
    input  wire `W_OPER oper,
    input  wire `W_REGF rd_regf,
    input  wire `W_DATA rd_data_a,
    input  wire `W_DATA rd_data_b,
    output wire `W_DATA rd_data,
    output wire `W_REGF rd_regf_out
    );

    assign rd_data = `IS_OPER_MEM ? rd_data_b : rd_data_a;
    assign rd_regf_out = rd_regf;
endmodule
