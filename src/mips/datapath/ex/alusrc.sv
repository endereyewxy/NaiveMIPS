`timescale 1ns/1ps

import includes::*;

module alusrc(
    input  logic `W_TYPE ityp           ,
    input  logic `W_FUNC func           ,
    input  logic `W_DATA imme           ,
    input  logic         forward_rs     ,
    input  logic `W_DATA forward_rs_data,
    input  logic         forward_rt     ,
    input  logic `W_DATA forward_rt_data,
    input  logic `W_DATA rs_data        ,
    input  logic `W_DATA rt_data        ,
    output logic `W_DATA source_a       ,
    output logic `W_DATA source_b       ,
    output logic `W_DATA source_data    );
    
    logic `W_DATA rs;
    logic `W_DATA rt;
    
    assign rs = forward_rs ? forward_rs_data : rs_data;
    assign rt = forward_rt ? forward_rt_data : rt_data;
    
    assign source_a =  ityp == `TYPE_R ? ((func == `FUNC_SLL | func == `FUNC_SRL | func == `FUNC_SRA)  ? rt : rs) :
                      (ityp == `TYPE_I &  (func == `FUNC_SLL | func == `FUNC_SRL | func == `FUNC_SRA)) ? rt : rs;
    assign source_b =  ityp == `TYPE_R ? ((func == `FUNC_SLL | func == `FUNC_SRL | func == `FUNC_SRA)  ? rs : rt) : imme;
    
    assign source_data = rt;
    
endmodule
