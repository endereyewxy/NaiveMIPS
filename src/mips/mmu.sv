`timescale 1ns / 1ps
`include"defines.vh"

module mmu(
    sram.slave   ibus_v   ,
    sram.slave   dbus_v   ,
    sram.master  ibus_p   ,
    sram.master  dbus_p   ,
    output logic no_dcache);
    
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
    
    assign {ibus_p.en, ibus_p.we, ibus_p.addr, ibus_p.data_w} = {ibus_v.en, ibus_v.we, inst_p_addr, ibus_v.data_w};
    assign {ibus_v.data_r, ibus_v.stall} = {ibus_p.data_r, ibus_p.stall};
    assign {dbus_p.en, dbus_p.we, dbus_p.addr, dbus_p.data_w} = {dbus_v.en, dbus_v.we, data_p_addr, dbus_v.data_w};
    assign {dbus_v.data_r, dbus_v.stall} = {dbus_p.data_r, dbus_p.stall};
    
    assign no_dcache = data_kesg1 ? 1'b1 : 1'b0;
    
endmodule
