`timescale 1ns/1ps
`include "defines.vh"

module mm(
    input         logic `W_OPER oper       ,
    input         logic         slot       ,
    input         logic `W_INTV intr_vect  ,
    ader.master                 ibus_ader  ,
    ader.master                 dbus_ader  ,
    input         logic         sy         ,
    input         logic         bp         ,
    input         logic         ri         ,
    input         logic         ov         ,
    input         logic         er         ,
    input         logic `W_ADDR er_epc     ,
    input         logic `W_ADDR pc         ,
    output        logic         except     ,
    output        logic `W_ADDR except_addr,
    regf_e.master               cp0_er     ,
    input         logic `W_ADDR source_addr,
    input         logic `W_DATA source_data,
    output        logic         dbus_en    ,
    output        logic [3:0]   dbus_we    ,
    output        logic `W_ADDR dbus_addr  ,
    output        logic `W_DATA dbus_data  );
    
    except except_(
        .slot       (slot       ),
        .intr_vect  (intr_vect  ),
        .ibus       (ibus_ader  ),
        .dbus       (dbus_addr  ),
        .sy         (sy         ),
        .bp         (bp         ),
        .ri         (ri         ),
        .ov         (ov         ),
        .er         (er         ),
        .er_epc     (er_epc     ),
        .pc         (pc         ),
        .except     (except     ),
        .except_addr(except_addr),
        .cp0_en     (cp0_er.we  ),
        .cp0_bd     (cp0_er.bd  ),
        .cp0_exl    (cp0_er.exl ),
        .cp0_exc    (cp0_er.exc ),
        .cp0_epc    (cp0_er.epc ),
        .cp0_bva    (cp0_er.bva ));
    
    memctl memctl_(
        .oper       (oper),       
        .source_addr(source_addr),
        .source_data(source_data),
        .dbus_en    (dbus_en),
        .dbus_we    (dbus_we),
        .dbus_addr  (dbus_addr),
        .dbus_data  (dbus_data));
    
endmodule

