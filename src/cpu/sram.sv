`timescale 1ns/1ps

import includes::*;

module mycpu_top(
    input  logic         clk              ,
    input  logic         resetn           ,
    input  logic `W_HINT int_             ,
    
    output logic         inst_sram_en     ,
    output logic [3:0]   inst_sram_wen    ,
    output logic `W_ADDR inst_sram_addr   ,
    output logic `W_DATA inst_sram_wdata  ,
    input  logic `W_DATA inst_sram_rdata  ,
    
    output logic         data_sram_en     ,
    output logic [3:0]   data_sram_wen    ,
    output logic `W_ADDR data_sram_addr   ,
    output logic `W_DATA data_sram_wdata  ,
    input  logic `W_DATA data_sram_rdata  ,
    
    output logic `W_DATA debug_wb_pc      ,
    output logic [3:0]   debug_wb_rf_wen  ,
    output logic `W_REGF debug_wb_rf_wnum ,
    output logic `W_DATA debug_wb_rf_wdata);
    
    sbus ibus(clk);
    sbus dbus(clk);
    
    debuginfo debug;
    
    mips mips_(
        .clk       (clk       ),
        .rst       (~resetn    ),
        .hard_intr (int_       ),
        .ibus_sbus (ibus.master),
        .dbus_sbus (dbus.master),
        .debug     (debug      ));
    
    sbus_to_sram bridge_ibus(
        .clk       (clk            ),
        .rst       (~resetn        ),
        .sbus      (ibus.slave     ),
        .sram_en   (inst_sram_en   ),
        .sram_we   (inst_sram_wen  ),
        .sram_addr (inst_sram_addr ),
        .sram_wdata(inst_sram_wdata),
        .sram_rdata(inst_sram_rdata));
    
    sbus_to_sram bridge_dbus(
        .clk       (clk            ),
        .rst       (~resetn        ),
        .sbus      (dbus.slave     ),
        .sram_en   (data_sram_en   ),
        .sram_we   (data_sram_wen  ),
        .sram_addr (data_sram_addr ),
        .sram_wdata(data_sram_wdata),
        .sram_rdata(data_sram_rdata));
    
    assign {debug_wb_pc, debug_wb_rf_wen, debug_wb_rf_wnum, debug_wb_rf_wdata} = debug;
    
endmodule

