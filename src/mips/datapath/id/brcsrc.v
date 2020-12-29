`timescale 1ns / 1ps
`include "defines.vh"

module brcsrc(
    input  wire         forward_rs     ,
    input  wire         forward_rt     ,
    input  wire `W_DATA forward_rs_data,
    input  wire `W_DATA forward_rt_data,
    input  wire `W_DATA rs_data        ,
    input  wire `W_DATA rt_data        ,
    output wire `W_DATA source_a       ,
    output wire `W_DATA source_b       );
    
    assign source_a = forward_rs ? forward_rs_data : rs_data;
    assign source_b = forward_rt ? forward_rt_data : rt_data;

endmodule

