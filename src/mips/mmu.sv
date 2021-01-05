`timescale 1ns/1ps

import includes::*;

module mmu(
    sbus.slave            ibus_v   ,
    sbus.slave            dbus_v   ,
    sbus.master           ibus_p   ,
    sbus.master           dbus_p   ,
    output      bus_error ibus_e   ,
    output      bus_error dbus_e   ,
    output      logic     no_dcache);
    
    // 映射地址
    
    logic inst_kesg0, inst_kesg1;
    logic data_kesg0, data_kesg1;
    
    assign inst_kesg0 = ibus_v.addr[31:29] == 3'b100;
    assign inst_kesg1 = ibus_v.addr[31:29] == 3'b101;
    assign data_kesg0 = dbus_v.addr[31:29] == 3'b100;
    assign data_kesg1 = dbus_v.addr[31:29] == 3'b101;
    
    logic `W_ADDR inst_p_addr;
    logic `W_ADDR data_p_addr;
    
    assign inst_p_addr = inst_kesg0 | inst_kesg1 ? {3'b0, ibus_v.addr[28:0]} : ibus_v.addr;
    assign data_p_addr = data_kesg0 | data_kesg1 ? {3'b0, dbus_v.addr[28:0]} : dbus_v.addr;
    
    // 处理地址异常
    
    logic  ibus_e_en;
    assign ibus_e_en   = ~(ibus_v.size == 2'b00 | ibus_v.addr[1:0] == 2'b00 | (ibus_v.size == 2'b01 & ibus_v.addr[1:0] == 2'b10));
    assign ibus_e.adel = ibus_e_en;
    assign ibus_e.ades = 1'b0;
    assign ibus_e.addr = ibus_v.addr;
    
    logic  dbus_e_en;
    assign dbus_e_en   = ~(dbus_v.size == 2'b00 | dbus_v.addr[1:0] == 2'b00 | (dbus_v.size == 2'b01 & dbus_v.addr[1:0] == 2'b10));
    assign dbus_e.adel = dbus_e_en & ~dbus_v.we;
    assign dbus_e.ades = dbus_e_en &  dbus_v.we;
    assign dbus_e.addr = dbus_v.addr;
    
    // 连接总线（发生异常时不进行请求）
    
    assign ibus_p.en     = ibus_v.en & ~ibus_e_en;
    assign ibus_p.we     = ibus_v.we;
    assign ibus_p.size   = ibus_v.size;
    assign ibus_p.addr   = inst_p_addr;
    assign ibus_p.data_w = ibus_v.data_w;
    assign ibus_v.data_r = ibus_p.data_r;
    assign ibus_p.pause  = ibus_v.pause;
    assign ibus_v.stall  = ibus_p.stall;
    
    assign dbus_p.en     = dbus_v.en & ~dbus_e_en;
    assign dbus_p.we     = dbus_v.we;
    assign dbus_p.size   = dbus_v.size;
    assign dbus_p.addr   = data_p_addr;
    assign dbus_p.data_w = dbus_v.data_w;
    assign dbus_v.data_r = dbus_p.data_r;
    assign dbus_p.pause  = dbus_v.pause;
    assign dbus_v.stall  = dbus_p.stall;
    
    assign no_dcache = data_kesg1 ? 1'b1 : 1'b0;
    
endmodule

