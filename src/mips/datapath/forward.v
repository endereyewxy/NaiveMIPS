`timescale 1ns/1ps
`include "defines.vh"

module forward(
    input  wire `W_OPER oper_id           ,
    input  wire `W_OPER oper_ex           ,
    input  wire `W_OPER oper_mm           ,
    input  wire `W_REGF from_ex_regf      ,
    input  wire `W_DATA from_ex_data      ,
    input  wire `W_REGF from_mm_regf      ,
    input  wire `W_DATA from_mm_data      ,
    input  wire `W_REGF from_wb_regf      ,
    input  wire `W_DATA from_wb_data      ,
    input  wire `W_REGF into_id_rs        ,
    input  wire `W_REGF into_id_rt        ,
    input  wire `W_REGF into_ex_rs        ,
    input  wire `W_REGF into_ex_rt        ,
    output wire         stall             ,
    output wire         forward_id_rs     ,
    output wire `W_DATA forward_id_rs_data,
    output wire         forward_id_rt     ,
    output wire `W_DATA forward_id_rt_data,
    output wire         forward_ex_rs     ,
    output wire `W_DATA forward_ex_rs_data,
    output wire         forward_ex_rt     ,
    output wire `W_DATA forward_ex_rt_data);
    
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
    
    wire is_id_jb ;
    wire is_ex_mem;
    wire is_mm_mem;
    
    assign is_id_jb  = (oper_id & 5'b11000) == 5'b01000; // 参考defines.vh
    assign is_ex_mem = (oper_ex & 5'b11000) == 5'b10000;
    assign is_mm_mem = (oper_mm & 5'b11000) == 5'b10000;
    
    wire id_ex;
    wire id_mm;
    
    assign id_ex = from_ex_regf == into_id_rs | from_ex_regf == into_id_rt;
    assign id_mm = from_mm_regf == into_id_rs | from_mm_regf == into_id_rt;
    
    assign stall =
        (id_ex & is_id_jb ) |
        (id_ex & is_ex_mem) |
        (id_mm & is_id_jb ) ;
    
endmodule

