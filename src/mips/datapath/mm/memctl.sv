`timescale 1ns/1ps
`include "defines.vh"

module memctl(
    input  logic `W_OPER oper       ,
    input  logic `W_ADDR source_addr,
    input  logic `W_DATA source_data,
    input  logic `W_ADDR pc         ,
    output logic         dbus_en    ,
    output logic [3:0]   dbus_we    ,
    output logic `W_ADDR dbus_addr  ,
    output logic `W_DATA dbus_data
    );

    assign dbus_en   = `IS_OPER_MM(oper)     ? 1'b1 : 1'b0   ;

    assign dbus_we   =  oper == `OPER_SB    ? 4'b0001    :
                        oper == `OPER_SH    ? 4'b0011    :
                        oper == `OPER_SW    ? 4'b1111    : 4'b0000;
    assign dbus_addr =  source_addr;

    assign dbus_data =  `IS_OPER_JB(oper)                                        ? pc + 8      :
                        (oper == `OPER_SB | oper == `OPER_SH | oper == `OPER_SW) ? source_data : source_addr;
endmodule

