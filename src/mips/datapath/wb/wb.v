`timescale 1ns / 1ps
module wb(
    input  wire `W_OPER oper,
    input  wire `W_REGF rd_regf,
    input  wire `W_DATA rd_data_a,
    input  wire `W_DATA rd_data_b,
    output wire `W_DATA rd_data,
    output wire `W_REGF rd_regf_out
    );

    regsrc regsrc_(oper,rd_regf,rd_data_a,rd_data_b,rd_data,rd_regf_out);

endmodule
