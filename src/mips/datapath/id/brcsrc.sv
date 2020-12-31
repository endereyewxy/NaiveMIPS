`timescale 1ns/1ps

import includes::*;

module brcsrc(
    input  logic         forward_rs     ,
    input  logic         forward_rt     ,
    input  logic `W_DATA forward_rs_data,
    input  logic `W_DATA forward_rt_data,
    input  logic `W_DATA rs_data        ,
    input  logic `W_DATA rt_data        ,
    output logic `W_DATA source_a       ,
    output logic `W_DATA source_b       );
    
    assign source_a = forward_rs ? forward_rs_data : rs_data;
    assign source_b = forward_rt ? forward_rt_data : rt_data;

endmodule

