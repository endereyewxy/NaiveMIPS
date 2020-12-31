`timescale 1ns/1ps

import includes::*;

module regsrc(
    input       logic `W_OPER oper        ,
    input       logic `W_REGF rd_regf     ,
    input       logic `W_DATA rd_data_a   ,
    input       logic `W_DATA rd_data_b   ,
    input       logic `W_ADDR pc          ,
    regf_w.master             rd          );
    
    function logic `W_DATA do_load_instr(input logic `W_OPER oper     ,
                                         input logic `W_DATA rd_data_b);
        case (oper)
            `OPER_LB : do_load_instr = {{24{rd_data_b[7 ]}}, rd_data_b[7 :0]};
            `OPER_LBU: do_load_instr = { 24'h0             , rd_data_b[7 :0]};
            `OPER_LH : do_load_instr = {{16{rd_data_b[15]}}, rd_data_b[15:0]};
            `OPER_LHU: do_load_instr = { 16'h0             , rd_data_b[15:0]};
            default  : do_load_instr =                       rd_data_b       ;
        endcase
    endfunction
    
    assign rd.data = `IS_OPER_JB(oper)  ? pc + 8                         :
                     `IS_OPER_MM(oper)  ? do_load_instr(oper, rd_data_b) : rd_data_a;
    assign rd.regf = oper == `OPER_MTC0 ? 0                              : rd_regf  ;
    
endmodule

