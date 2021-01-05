`timescale 1ns/1ps

import includes::*;

module ex(
    input  logic         clk            ,
    input  logic         rst            ,
    input  logic         reg_stall      ,
    input  logic         reg_flush      ,
    output logic         alu_stall      ,
    input  logic `W_TYPE ityp           ,
    input  logic `W_OPER oper           ,
    input  logic `W_FUNC func           ,
    input  logic `W_DATA imme           ,
    input  logic         forward_rs     ,
    input  logic `W_DATA forward_rs_data,
    input  logic         forward_rt     ,
    input  logic `W_DATA forward_rt_data,
    input  logic `W_DATA rs_data        ,
    input  logic `W_DATA rt_data        ,
    input  logic `W_DATA cp0_rt_data    ,
    output logic         cp0_rd_we      ,
    output logic `W_DATA cp0_rd_data    ,
    output logic `W_DATA result         ,
    output logic         ov             ,
    output logic `W_DATA source_data    );
    
    logic `W_DATA source_a;
    logic `W_DATA source_b;
    
    logic         mulalu_sign;
    logic `W_FUNC mulalu_func;
    
    logic `W_DATA hi;
    logic `W_DATA lo;
    logic `W_DATA hi_write_data;
    logic `W_DATA lo_write_data;
    
    logic hi_write;
    logic lo_write;
    
    alusrc alusrc_(
        .ityp           (ityp           ),
        .func           (func           ),
        .imme           (imme           ),
        .forward_rs     (forward_rs     ),
        .forward_rs_data(forward_rs_data),
        .forward_rt     (forward_rt     ),
        .forward_rt_data(forward_rt_data),
        .rs_data        (rs_data        ),
        .rt_data        (rt_data        ),
        .source_a       (source_a       ),
        .source_b       (source_b       ),
        .source_data    (source_data    ));
    
    sglalu sglalu_(
        .oper         (oper       ),
        .func         (func       ),
        .cp0_rt_data  (cp0_rt_data),
        .cp0_rd_we    (cp0_rd_we  ),
        .cp0_rd_data  (cp0_rd_data),
        .source_a     (source_a   ),
        .source_b     (source_b   ),
        .result       (result     ),
        .mulalu_sign  (mulalu_sign),
        .mulalu_func  (mulalu_func),
        .hi           (hi         ),
        .hi_write     (hi_write   ),
        .lo           (lo         ),
        .lo_write     (lo_write   ),
        .ov           (ov         ));
    
    mulalu mulalu_(
        .clk          (clk        ),
        .rst          (rst        ),
        .reg_stall    (reg_stall  ),
        .reg_flush    (reg_flush  ),
        .alu_stall    (alu_stall  ),
        .sign         (mulalu_sign),
        .func         (mulalu_func),
        .source_a     (source_a   ),
        .source_b     (source_b   ),
        .hi           (hi         ),
        .hi_write     (hi_write   ),
        .hi_write_data(source_a   ),
        .lo           (lo         ),
        .lo_write     (lo_write   ),
        .lo_write_data(source_a   ));
    
endmodule

