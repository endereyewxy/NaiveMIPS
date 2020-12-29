`timescale 1ns/1ps
`include "defines.vh"

module except(
    input  logic         slot       ,
    input  logic `W_INTV intr_vect  ,
           ader.master   ibus       ,
           ader.master   dbus       ,
    input  logic         sy         ,
    input  logic         bp         ,
    input  logic         ri         ,
    input  logic         ov         ,
    input  logic         er         ,
    input  logic `W_ADDR er_epc     ,
    input  logic `W_ADDR pc         ,
    output logic         except     ,
    output logic `W_ADDR except_addr,
    output logic         cp0_en     ,
    output logic         cp0_bd     ,
    output logic         cp0_exl    ,
    output logic `W_EXCC cp0_exc    ,
    output logic `W_ADDR cp0_epc    ,
    output logic `W_ADDR cp0_bva    );
    
    logic actual_except;
    
    assign {actual_except, cp0_exc} =
        (intr_vect != 0)        ? {1'b1, `EXCC_INT } :
         ibus.adel              ? {1'b1, `EXCC_ADEL} :
         ri                     ? {1'b1, `EXCC_RI  } :
         ov                     ? {1'b1, `EXCC_OV  } :
         bp                     ? {1'b1, `EXCC_BP  } :
         sy                     ? {1'b1, `EXCC_SY  } :
        (dbus.ades | dbus.ades) ? {1'b1, `EXCC_ADES} : 0;
    
    assign except      = actual_except | er;
    assign except_addr = actual_except ? 32'hbfc00380 : er ? er_epc : 0;
    
    assign cp0_en  = actual_except;
    assign cp0_bd  = actual_except & slot;
    assign cp0_exl = actual_except;
    assign cp0_epc = slot ? (pc - 4) : pc;
    assign cp0_bva = ibus.adel ? ibus.addr : (dbus.adel | dbus.ades) ? dbus.addr : 0;
    
endmodule

