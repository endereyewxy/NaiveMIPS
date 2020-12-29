`timescale 1ns/1ps
`include "defines.vh"

module forward(
    input  logic `W_OPER oper_id           ,
    input  logic `W_OPER oper_ex           ,
    input  logic `W_OPER oper_mm           ,
    input  logic `W_REGF from_ex_regf      ,
    input  logic `W_DATA from_ex_data      ,
    input  logic `W_REGF from_mm_regf      ,
    input  logic `W_DATA from_mm_data      ,
    input  logic `W_REGF from_wb_regf      ,
    input  logic `W_DATA from_wb_data      ,
    input  logic `W_REGF into_id_rs        ,
    input  logic `W_REGF into_id_rt        ,
    input  logic `W_REGF into_ex_rs        ,
    input  logic `W_REGF into_ex_rt        ,
    output logic         stall             ,
    output logic         forward_id_rs     ,
    output logic `W_DATA forward_id_rs_data,
    output logic         forward_id_rt     ,
    output logic `W_DATA forward_id_rt_data,
    output logic         forward_ex_rs     ,
    output logic `W_DATA forward_ex_rs_data,
    output logic         forward_ex_rt     ,
    output logic `W_DATA forward_ex_rt_data);
    
    assign {forward_id_rs, forward_id_rs_data} =
        (from_ex_regf != 0 & from_ex_regf == into_id_rs) ? {1'b1, from_ex_data} :
        (from_mm_regf != 0 & from_mm_regf == into_id_rs) ? {1'b1, from_mm_data} :
        (from_wb_regf != 0 & from_wb_regf == into_id_rs) ? {1'b1, from_wb_data} : 0;
    
    assign {forward_id_rt, forward_id_rt_data} =
        (from_ex_regf != 0 & from_ex_regf == into_id_rt) ? {1'b1, from_ex_data} :
        (from_mm_regf != 0 & from_mm_regf == into_id_rt) ? {1'b1, from_mm_data} :
        (from_wb_regf != 0 & from_wb_regf == into_id_rt) ? {1'b1, from_wb_data} : 0;
    
    assign {forward_ex_rs, forward_ex_rs_data} =
        (from_mm_regf != 0 & from_mm_regf == into_ex_rs) ? {1'b1, from_mm_data} :
        (from_wb_regf != 0 & from_wb_regf == into_ex_rs) ? {1'b1, from_wb_data} : 0;
    
    assign {forward_ex_rt, forward_ex_rt_data} =
        (from_mm_regf != 0 & from_mm_regf == into_ex_rt) ? {1'b1, from_mm_data} :
        (from_wb_regf != 0 & from_wb_regf == into_ex_rt) ? {1'b1, from_wb_data} : 0;
    
    // 三种情况需要停顿：
    // 1. ID依赖EX，并且ID是分支指令；
    // 2. ID依赖EX，并且EX是访存指令；
    // 3. ID依赖MM，并且ID是分支指令。
    
    logic is_id_jb;
    logic is_ex_mm;
    
    assign is_id_jb = `IS_OPER_JB(oper_id);
    assign is_ex_mm = `IS_OPER_MM(oper_ex);
    
    logic id_ex;
    logic id_mm;
    
    assign id_ex = from_ex_regf == into_id_rs | from_ex_regf == into_id_rt;
    assign id_mm = from_mm_regf == into_id_rs | from_mm_regf == into_id_rt;
    
    assign stall =
        (id_ex & is_id_jb) |
        (id_ex & is_ex_mm) |
        (id_mm & is_id_jb) ;
    
endmodule

