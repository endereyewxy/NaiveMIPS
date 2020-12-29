`timescale 1ns/1ps
`include "defines.vh"

module except(
    input         logic         slot       ,
    input         logic `W_INTV intr_vect  ,
    ader.master                 ibus       ,
    ader.master                 dbus       ,
    input         logic         sy         ,
    input         logic         bp         ,
    input         logic         ri         ,
    input         logic         ov         ,
    input         logic         er         ,
    input         logic `W_ADDR er_epc     ,
    input         logic `W_ADDR pc         ,
    output        logic         except     ,
    output        logic `W_ADDR except_addr,
    regf_e.master               cp0        );
    
    logic actual_except;
    
    assign {actual_except, cp0.exc} =
        (intr_vect != 0)        ? {1'b1, `EXCC_INT } :
         ibus.adel              ? {1'b1, `EXCC_ADEL} :
         ri                     ? {1'b1, `EXCC_RI  } :
         ov                     ? {1'b1, `EXCC_OV  } :
         bp                     ? {1'b1, `EXCC_BP  } :
         sy                     ? {1'b1, `EXCC_SY  } :
        (dbus.ades | dbus.ades) ? {1'b1, `EXCC_ADES} : 0;
    
    assign except      = actual_except | er;
    assign except_addr = actual_except ? 32'hbfc00380 : er ? er_epc : 0;
    
    assign cp0.we  = actual_except;
    assign cp0.bd  = actual_except & slot;
    assign cp0.exl = actual_except;
    assign cp0.epc = slot ? (pc - 4) : pc;
    assign cp0.bva = ibus.adel ? ibus.addr : (dbus.adel | dbus.ades) ? dbus.addr : 0;
    
endmodule

