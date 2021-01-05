`timescale 1ns/1ps

import includes::*;

module mycpu_top(
    input  logic         clk              ,
    input  logic         resetn           ,
    input  logic `W_HINT int_             ,
    
    output logic `W_DATA debug_wb_pc      ,
    output logic [3:0]   debug_wb_rf_wen  ,
    output logic `W_REGF debug_wb_rf_wnum ,
    output logic `W_DATA debug_wb_rf_wdata,
    
    output logic [3 :0] arid              ,
    output logic [31:0] araddr            ,
    output logic [7 :0] arlen             ,
    output logic [2 :0] arsize            ,
    output logic [1 :0] arburst           ,
    output logic [1 :0] arlock            ,
    output logic [3 :0] arcache           ,
    output logic [2 :0] arprot            ,
    output logic        arvalid           ,
    input  logic        arready           ,
    input  logic [3 :0] rid               ,
    input  logic [31:0] rdata             ,
    input  logic [1 :0] rresp             ,
    input  logic        rlast             ,
    input  logic        rvalid            ,
    output logic        rready            ,
    output logic [3 :0] awid              ,
    output logic [31:0] awaddr            ,
    output logic [7 :0] awlen             ,
    output logic [2 :0] awsize            ,
    output logic [1 :0] awburst           ,
    output logic [1 :0] awlock            ,
    output logic [3 :0] awcache           ,
    output logic [2 :0] awprot            ,
    output logic        awvalid           ,
    input  logic        awready           ,
    output logic [3 :0] wid               ,
    output logic [31:0] wdata             ,
    output logic [3 :0] wstrb             ,
    output logic        wlast             ,
    output logic        wvalid            ,
    input  logic        wready            ,
    input  logic [3 :0] bid               ,
    input  logic [1 :0] bresp             ,
    input  logic        bvalid            ,
    output logic        bready            );
    
    sbus ibus(clk);
    sbus dbus(clk);
    
    debuginfo debug;
    
    logic no_dcache;
    
    mips mips_(
        .clk        (clk        ),
        .rst        (~resetn    ),
        .hard_intr  (int_       ),
        .ibus_sbus  (ibus.master),
        .dbus_sbus  (dbus.master),
        .no_dcache  (no_dcache  ),
        .debug      (debug      ));
    
    toaxi bridge(.rst(~resetn), .ibus(ibus.slave), .dbus(dbus.slave), .*);
    
    assign {debug_wb_pc, debug_wb_rf_wen, debug_wb_rf_wnum, debug_wb_rf_wdata} = debug;
    
endmodule

