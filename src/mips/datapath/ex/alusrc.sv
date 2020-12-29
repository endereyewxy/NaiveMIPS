`timescale 1ns / 1ps
`include "defines.vh"

module alusrc(
    input  logic `W_TYPE ityp,
    input  logic `W_OPER oper,
    input  logic `W_DATA imme,
    input  logic forward_rs,
    input  logic `W_DATA forward_rs_data,
    input  logic forward_rt,
    input  logic `W_DATA forward_rt_data,
    input  logic `W_DATA rs_data,
    input  logic `W_DATA rt_data,
    output logic `W_DATA source_a,
    output logic `W_DATA source_b
    );
           logic `W_DATA rs;
           logic `W_DATA rt;
    assign rs = forward_rs ? forward_rs_data : rs_data;
    assign rt = forward_rt ? forward_rt_data : rt_data;

    assign source_a = ((ityp == `TYPE_I) && (oper == `OPER_ALUS)) ? rt   : rs;

    assign source_b = (ityp == `TYPE_I)                           ? imme : rt;
                                             
    
endmodule
