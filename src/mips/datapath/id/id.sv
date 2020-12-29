`timescale 1ns / 1ps
`include"defines.vh"

module id(
    input  logic `W_DATA pc             ,
    input  logic `W_DATA inst           ,
    input  logic `W_DATA rs_data        ,
    input  logic `W_DATA rt_data        ,
    input  logic         forward_rs     ,
    input  logic `W_DATA forward_rs_data,
    input  logic         forward_rt     ,
    input  logic `W_DATA forward_rt_data,
    output logic `W_TYPE ityp           ,
    output logic `W_OPER oper           ,
    output logic `W_FUNC func           ,
    output logic `W_DATA imme           ,
    output logic `W_REGF rs_regf        ,
    output logic `W_REGF rt_regf        ,
    output logic `W_REGF rd_regf        ,
    output logic         branch         ,
    output logic `W_ADDR branch_addr    ,
    output logic         sy             ,
    output logic         bp             ,
    output logic         ri             ,
    output logic         er             );

    decode decode_(
        .inst   (inst   ),
        .ityp   (ityp   ),
        .oper   (oper   ),
        .func   (func   ),
        .imme   (imme   ),
        .rs_regf(rs_regf),
        .rt_regf(rt_regf),
        .rd_regf(rd_regf),
        .sy     (sy     ),
        .bp     (bp     ),
        .ri     (ri     ),
        .er     (er     ));

    logic `W_DATA srca;
    logic `W_DATA srcb;

    brcsrc brcsrc_(
        .forward_rs     (forward_rs     ),
        .forward_rt     (forward_rt     ),
        .forward_rs_data(forward_rs_data),
        .forward_rt_data(forward_rt_data),
        .rs_data        (rs_data        ),
        .rt_data        (rt_data        ),
        .source_a       (srca           ),
        .source_b       (srcb           ));
    
    branch branch_(
        .oper       (oper       ),
        .imme       (imme       ),
        .source_a   (srca       ),
        .source_b   (srcb       ),
        .pc         (pc         ),
        .branch     (branch     ),
        .branch_addr(branch_addr));
    
endmodule

