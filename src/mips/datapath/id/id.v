`timescale 1ns / 1ps
`include"defines.vh"
module id(
    input  wire `W_DATA pc             ,
    input  wire `W_DATA inst           ,
    input  wire `W_DATA rs_data        ,
    input  wire `W_DATA rt_data        ,
    input  wire         forward_rs     ,
    input  wire `W_DATA forward_rs_data,
    input  wire         forward_rt     ,
    input  wire `W_DATA forward_rt_data,
    output wire `W_TYPE type           ,
    output wire `W_OPER oper           ,
    output wire `W_FUNC func           ,
    output wire `W_DATA imme           ,
    output wire `W_REGF rs_regf        ,
    output wire `W_REGF rt_regf        ,
    output wire `W_REGF rd_regf        ,
    output wire         branch         ,
    output wire `W_ADDR branch_addr    ,
    output wire         sy             ,
    output wire         bp             ,
    output wire         ri             ,
    output wire         er             );

    decode decode_(
        .inst(inst),
        .type(type),
        .oper(oper),
        .func(func),
        .imme(imme),
        .rs_regf(rs_regf),
        .rt_regf(rt_regf),
        .rd_regf(rd_regf),
        .sy(sy),
        .bp(bp),
        .ri(ri),
        .er(er)
    );

    wire `W_DATA srca;
    wire `W_DATA srcb;

    brcsrc brcsrc_(
    .forward_rs(forward_rs),
    .forward_rt(forward_rt),
    .forward_rs_data(forward_rs_data),
    .forward_rt_data(forward_rt_data),
    .rs_data(rs_data),
    .rt_data(rt_data),
    .source_a(srca),
    .source_b(srcb)
    );
    
    branch branch_(
    .oper(oper),
    .imme(imme),
    .source_a(srca),
    .source_b(srcb),
    .pc(pc),
    .branch(branch),
    .branch_addr(branch_addr)
    );
    
endmodule
