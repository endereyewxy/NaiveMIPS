`timescale 1ns/1ps
`include "defines.vh"

module mm(
    input  logic `W_OPER oper       ,
    input  logic         slot       ,
    input  logic `W_ADDR pc         ,
    input  bus_error     ibus_error ,
    input  bus_error     dbus_error ,
    input  exe_error     exec_error ,
    output reg_error     cp0w_error ,
    output logic         except     ,
    output logic `W_ADDR except_addr,
    input  logic `W_ADDR source_addr,
    input  logic `W_DATA source_data,
    output logic         dbus_en    ,
    output logic [3:0]   dbus_we    ,
    output logic `W_ADDR dbus_addr  ,
    output logic `W_DATA dbus_data  ,
    output logic [1:0]   word_offset);
    
    except except_(
        .slot       (slot       ),
        .pc         (pc         ),
        .ibus       (ibus_error ),
        .dbus       (dbus_error ),
        .exec       (exec_error ),
        .cp0w       (cp0w_error ),
        .except     (except     ),
        .except_addr(except_addr));
    
    memctl memctl_(
        .oper       (oper       ),       
        .source_addr(source_addr),
        .source_data(source_data),
        .dbus_en    (dbus_en    ),
        .dbus_we    (dbus_we    ),
        .dbus_addr  (dbus_addr  ),
        .dbus_data  (dbus_data  ),
        .word_offset(word_offset));
    
endmodule

