`timescale 1ns/1ps

import includes::*;

module memctl(
    input  logic `W_OPER oper       ,
    input  logic `W_ADDR source_addr,
    input  logic `W_DATA source_data,
    output logic         dbus_en    ,
    output logic         dbus_we    ,
    output logic [1:0]   dbus_size  ,
    output logic `W_ADDR dbus_addr  ,
    output logic `W_DATA dbus_data  );
    
    assign dbus_en   = `IS_OPER_MM(oper);
    assign dbus_we   =  oper == `OPER_SB  | oper == `OPER_SH | oper == `OPER_SW;
    assign dbus_size = (oper == `OPER_SW  |
                        oper == `OPER_LW  ) ? 2'b10 : // 读写四个字节
                       (oper == `OPER_SH  |
                        oper == `OPER_LH  |
                        oper == `OPER_LHU ) ? 2'b01 : // 读写两个字节
                                              2'b00 ; // 读写一个字节
    assign dbus_addr = source_addr;
    assign dbus_data = dbus_we ?  source_data : source_addr;
    
endmodule

