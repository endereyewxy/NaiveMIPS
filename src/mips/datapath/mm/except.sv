`timescale 1ns/1ps

import includes::*;

module except(
    input  logic         slot       ,
    input  logic `W_ADDR pc         ,
    input  bus_error     ibus       ,
    input  bus_error     dbus       ,
    input  exe_error     exec       ,
    output reg_error     cp0w       ,
    output logic         except     ,
    output logic `W_ADDR except_addr);
    
    logic actual_except;
    
    assign {actual_except, cp0w.exc} =
        (exec.intr_vect != 0)   ? {1'b1, `EXCC_INT } :
        (ibus.adel | dbus.adel) ? {1'b1, `EXCC_ADEL} :
         exec.ri                ? {1'b1, `EXCC_RI  } :
         exec.ov                ? {1'b1, `EXCC_OV  } :
         exec.bp                ? {1'b1, `EXCC_BP  } :
         exec.sy                ? {1'b1, `EXCC_SY  } :
         dbus.ades              ? {1'b1, `EXCC_ADES} : 0;
    
    assign except      = actual_except | exec.er;
    assign except_addr = actual_except ? 32'hbfc00380 : exec.er ? exec.er_epc : 0;
    
    assign cp0w.we  = actual_except;
    assign cp0w.bd  = actual_except & slot;
    assign cp0w.exl = actual_except;
    assign cp0w.epc = slot ? (pc - 4) : pc;
    assign cp0w.bva = ibus.adel ? ibus.addr : (dbus.adel | dbus.ades) ? dbus.addr : 0;
    
endmodule

