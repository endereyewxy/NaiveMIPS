`timescale 1ns/1ps

import includes::*;

module toaxi(
    input logic         clk      ,
    input logic         rst      ,
    
    sbus.slave          ibus     ,
    sbus.slave          dbus     ,
    
    input  logic        no_dcache,

    output logic [3 :0] arid     ,
    output logic [31:0] araddr   ,
    output logic [7 :0] arlen    ,
    output logic [2 :0] arsize   ,
    output logic [1 :0] arburst  ,
    output logic [1 :0] arlock   ,
    output logic [3 :0] arcache  ,
    output logic [2 :0] arprot   ,
    output logic        arvalid  ,
    input  logic        arready  ,
    input  logic [3 :0] rid      ,
    input  logic [31:0] rdata    ,
    input  logic [1 :0] rresp    ,
    input  logic        rlast    ,
    input  logic        rvalid   ,
    output logic        rready   ,
    output logic [3 :0] awid     ,
    output logic [31:0] awaddr   ,
    output logic [7 :0] awlen    ,
    output logic [2 :0] awsize   ,
    output logic [1 :0] awburst  ,
    output logic [1 :0] awlock   ,
    output logic [3 :0] awcache  ,
    output logic [2 :0] awprot   ,
    output logic        awvalid  ,
    input  logic        awready  ,
    output logic [3 :0] wid      ,
    output logic [31:0] wdata    ,
    output logic [3 :0] wstrb    ,
    output logic        wlast    ,
    output logic        wvalid   ,
    input  logic        wready   ,
    input  logic [3 :0] bid      ,
    input  logic [1 :0] bresp    ,
    input  logic        bvalid   ,
    output logic        bready   );
    
    logic [3:0]   ibus_mask_w;
    logic `W_DATA ibus_data_w;
    logic `W_DATA ibus_data_r;
    
    align ibus_align(
        .clk    (clk                    ),
        .rst    (rst                    ),
        .stall  (ibus.stall | ibus.pause),
        .addr   (ibus.addr[1:0]         ),
        .size   (ibus.size              ),
        .data_wi(ibus.data_w            ),
        .data_ri(ibus_data_r            ),
        .mask_wo(ibus_mask_w            ),
        .data_wo(ibus_data_w            ),
        .data_ro(ibus.data_r            ));
    
    logic [3:0]   dbus_mask_w;
    logic `W_DATA dbus_data_w;
    logic `W_DATA dbus_data_r;
    
    align dbus_align(
        .clk    (clk                    ),
        .rst    (rst                    ),
        .stall  (dbus.stall | dbus.pause),
        .addr   (dbus.addr[1:0]         ),
        .size   (dbus.size              ),
        .data_wi(dbus.data_w            ),
        .data_ri(dbus_data_r            ),
        .mask_wo(dbus_mask_w            ),
        .data_wo(dbus_data_w            ),
        .data_ro(dbus.data_r            ));
    
    logic        inst_req    ;
    logic        inst_wr     ;
    logic [1 :0] inst_size   ;
    logic [31:0] inst_addr   ;
    logic [31:0] inst_wdata  ;
    logic [31:0] inst_rdata  ;
    logic        inst_addr_ok;
    logic        inst_data_ok;
    
    cache icache(
        .clk       (clk         ),
        .rst       (rst         ),
        .cpu_en    (ibus.en     ),
        .cpu_we    (ibus.we     ),
        .cpu_addr  (ibus.addr   ),
        .cpu_mask_w(ibus_mask_w ),
        .cpu_data_w(ibus_data_w ),
        .cpu_data_r(ibus_data_r ),
        .cpu_pause (ibus.pause  ),
        .cpu_stall (ibus.stall  ),
        .mem_en    (inst_req    ),
        .mem_we    (inst_wr     ),
        .mem_size  (inst_size   ),
        .mem_addr  (inst_addr   ),
        .mem_data_w(inst_wdata  ),
        .mem_data_r(inst_rdata  ),
        .mem_addr_o(inst_addr_ok),
        .mem_data_o(inst_data_ok));
    
    logic        data_req    ;
    logic        data_wr     ;
    logic [1 :0] data_size   ;
    logic [31:0] data_addr   ;
    logic [31:0] data_wdata  ;
    logic [31:0] data_rdata  ;
    logic        data_addr_ok;
    logic        data_data_ok;
    
    logic        dcache_rq   ;
    logic        dcache_we   ;
    logic [1 :0] dcache_size ;
    logic [31:0] dcache_addr ;
    logic [31:0] dcache_wdata;
    
    logic        ncache_rq   ;
    logic        ncache_we   ;
    logic [1 :0] ncache_size ;
    logic [31:0] ncache_addr ;
    logic [31:0] ncache_wdata;
    
    logic  dcache_en;
    logic  ncache_en;
    assign dcache_en = dbus.en & ~no_dcache;
    assign ncache_en = dbus.en &  no_dcache;
    
    logic last_no_dcache;
    
    always @(posedge clk)
        if (rst) last_no_dcache <= 1'b0; else if (dbus.en & ~dbus.stall & ~dbus.pause) last_no_dcache <= no_dcache;
    
    assign {data_req, data_wr, data_size, data_addr, data_wdata} = last_no_dcache ? {ncache_rq, ncache_we, ncache_size, ncache_addr, ncache_wdata}
                                                                                  : {dcache_rq, dcache_we, dcache_size, dcache_addr, dcache_wdata};
    
    logic `W_DATA dcache_dr;
    logic         dcache_st;
    
    logic `W_DATA ncache_dr;
    logic         ncache_st;
    
    assign {dbus_data_r, dbus.stall} = last_no_dcache ? {ncache_dr, ncache_st}
                                                      : {dcache_dr, dcache_st}; 
    
    cache dcache(
        .clk       (clk         ),
        .rst       (rst         ),
        .cpu_en    (dcache_en   ),
        .cpu_we    (dbus.we     ),
        .cpu_addr  (dbus.addr   ),
        .cpu_mask_w(dbus_mask_w ),
        .cpu_data_w(dbus_data_w ),
        .cpu_data_r(dcache_dr   ),
        .cpu_pause (dbus.pause  ),
        .cpu_stall (dcache_st   ),
        .mem_en    (dcache_rq   ),
        .mem_we    (dcache_we   ),
        .mem_size  (dcache_size ),
        .mem_addr  (dcache_addr ),
        .mem_data_w(dcache_wdata),
        .mem_data_r(data_rdata  ),
        .mem_addr_o(data_addr_ok),
        .mem_data_o(data_data_ok));
    
     toslk ncache(
        .clk       (clk         ),
        .rst       (rst         ),
        .cpu_en    (ncache_en   ),
        .cpu_we    (dbus.we     ),
        .cpu_size  (dbus.size   ),
        .cpu_addr  (dbus.addr   ),
        .cpu_data_w(dbus_data_w ),
        .cpu_data_r(ncache_dr   ),
        .cpu_pause (dbus.pause  ),
        .cpu_stall (ncache_st   ),
        .mem_en    (ncache_rq   ),
        .mem_we    (ncache_we   ),
        .mem_size  (ncache_size ),
        .mem_addr  (ncache_addr ),
        .mem_data_w(ncache_wdata),
        .mem_data_r(data_rdata  ),
        .mem_addr_o(data_addr_ok),
        .mem_data_o(data_data_ok));
    
    cpu_axi_interface axi(.resetn(~rst), .*);
    
endmodule

