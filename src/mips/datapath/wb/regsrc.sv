`timescale 1ns/1ps
`include "defines.vh"

module regsrc(
    input       logic `W_OPER oper        ,
    input       logic `W_REGF rd_regf     ,
    input       logic `W_DATA rd_data_a   ,
    input       logic `W_DATA rd_data_b   ,
    input       logic `W_ADDR pc          ,
    regf_w.master             rd          );
    
    assign rd.data = `IS_OPER_JB(oper) ? pc + 8                                                   :
                     `IS_OPER_MM(oper) ? (
                        (oper == `OPER_LB ) ? {{24{rd_data_b[7 ]}}, rd_data_b[7 :0]} :
                        (oper == `OPER_LBU) ? {24'h0              , rd_data_b[7 :0]} :
                        (oper == `OPER_LH ) ? {{16{rd_data_b[15]}}, rd_data_b[15:0]} :
                        (oper == `OPER_LHU) ? {16'h0              , rd_data_b[15:0]} : rd_data_b) : rd_data_a;
    assign rd.regf = oper == `OPER_MTC0 ? 0                                                       : rd_regf  ;
    
endmodule

