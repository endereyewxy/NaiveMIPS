`timescale 1ns/1ps

import includes::*;

module sbus_to_cache(
    input      logic        clk         ,
    input      logic        rst         ,
    input      logic        ndc         ,
    
    sbus.slave              ibus        ,
    sbus.slave              dbus        ,
    
    input      logic        ibus_update ,
    input      logic        dbus_update ,
    
    output     logic        inst_req    ,
    output     logic        inst_wr     ,
    output     logic [1 :0] inst_size   ,
    output     logic [31:0] inst_addr   ,
    output     logic [31:0] inst_wdata  ,
    input      logic [31:0] inst_rdata  ,
    input      logic        inst_addr_ok,
    input      logic        inst_data_ok,
    
    output     logic        data_req    ,
    output     logic        data_wr     ,
    output     logic [1 :0] data_size   ,
    output     logic [31:0] data_addr   ,
    output     logic [31:0] data_wdata  ,
    input      logic [31:0] data_rdata  ,
    input      logic        data_addr_ok,
    input      logic        data_data_ok);
    
    cache cache_inst(
        .clk              (clk         ),
        .rst              (rst         ),
        .sbus_update      (ibus_update ),
        .sbus_en          (ibus.en     ),
        .sbus_we          (ibus.we     ),
        .sbus_size        (ibus.size   ),
        .sbus_addr        (ibus.addr   ),
        .sbus_data_w      (ibus.data_w ),
        .sbus_data_r      (ibus.data_r ),
        .sbus_stall       (ibus.stall  ),
        .sram_like_req    (inst_req    ),
        .sram_like_wr     (inst_wr     ),
        .sram_like_size   (inst_size   ),
        .sram_like_addr   (inst_addr   ),
        .sram_like_wdata  (inst_wdata  ),
        .sram_like_rdata  (inst_rdata  ),
        .sram_like_addr_ok(inst_addr_ok),
        .sram_like_data_ok(inst_data_ok));
    
    logic [31:0] c_dbus_data_r ;
    logic        c_dbus_stall  ;
    logic        c_data_req    ;
    logic        c_data_wr     ;
    logic [1 :0] c_data_size   ;
    logic [31:0] c_data_addr   ;
    logic [31:0] c_data_wdata  ;
    
    cache cache_data(
        .clk              (clk           ),
        .rst              (rst           ),
        .sbus_update      (dbus_update   ),
        .sbus_en          (dbus.en & ~ndc),
        .sbus_we          (dbus.we       ),
        .sbus_size        (dbus.size     ),
        .sbus_addr        (dbus.addr     ),
        .sbus_data_w      (dbus.data_w   ),
        .sbus_data_r      (c_dbus_data_r ),
        .sbus_stall       (c_dbus_stall  ),
        .sram_like_req    (c_data_req    ),
        .sram_like_wr     (c_data_wr     ),
        .sram_like_size   (c_data_size   ),
        .sram_like_addr   (c_data_addr   ),
        .sram_like_wdata  (c_data_wdata  ),
        .sram_like_rdata  (data_rdata    ),
        .sram_like_addr_ok(data_addr_ok  ),
        .sram_like_data_ok(data_data_ok  ));
    
    logic [31:0] n_dbus_data_r ;
    logic        n_dbus_stall  ;
    logic        n_data_req    ;
    logic        n_data_wr     ;
    logic [1 :0] n_data_size   ;
    logic [31:0] n_data_addr   ;
    logic [31:0] n_data_wdata  ;
    
    sbus_to_sram_like no_dcache_(
        .clk              (clk          ),
        .rst              (rst          ),
        .sbus_update      (dbus_update  ),
        .sbus_en          (dbus.en & ndc),
        .sbus_we          (dbus.we      ),
        .sbus_size        (dbus.size    ),
        .sbus_addr        (dbus.addr    ),
        .sbus_data_w      (dbus.data_w  ),
        .sbus_data_r      (n_dbus_data_r),
        .sbus_stall       (n_dbus_stall ),
        .sram_like_req    (n_data_req   ),
        .sram_like_wr     (n_data_wr    ),
        .sram_like_size   (n_data_size  ),
        .sram_like_addr   (n_data_addr  ),
        .sram_like_wdata  (n_data_wdata ),
        .sram_like_rdata  (data_rdata   ),
        .sram_like_addr_ok(data_addr_ok ),
        .sram_like_data_ok(data_data_ok ));
    
    // 根据最近一次有效信号来判断是否经过缓存
    
    logic valid_ndc;
    
    always @(posedge clk) begin
        if (rst)
            valid_ndc <= 1'b1;
        else if (dbus.en)
            valid_ndc <= ndc;
    end
    
    assign {dbus.data_r, dbus.stall, data_req, data_wr, data_size, data_addr, data_wdata} = (dbus.en ? ndc : valid_ndc)
        ? {n_dbus_data_r, n_dbus_stall, n_data_req, n_data_wr, n_data_size, n_data_addr, n_data_wdata}
        : {c_dbus_data_r, c_dbus_stall, c_data_req, c_data_wr, c_data_size, c_data_addr, c_data_wdata};
    
endmodule

