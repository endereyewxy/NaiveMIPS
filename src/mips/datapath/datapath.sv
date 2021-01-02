`timescale 1ns/1ps

import includes::*;

module datapath(
    input       logic         clk        ,
    input       logic         rst        ,
    input       logic `W_INTV intr_vect  ,  // ID
    input       logic `W_ADDR er_epc     ,  // ID
    sbus.master               ibus_sbus  ,  // IF - ID
    sbus.master               dbus_sbus  ,  // MM - WB
    output      logic         ibus_update,
    output      logic         dbus_update,
    input       bus_error     ibus_error ,  // IF
    input       bus_error     dbus_error ,  // MM
    output      reg_error     cp0w_error ,  // MM
    regf_r.master             cp0_rt     ,  // EX
    regf_w.master             cp0_rd     ,  // EX
    regf_r.master             rs         ,  // ID
    regf_r.master             rt         ,  // ID
    regf_w.master             rd         ,  // WB
    output      debuginfo     debug      );
    
    // 控制与前推信号定义
    
    logic c_if_id_stall;
    logic c_if_id_flush;
    logic c_id_ex_stall;
    logic c_id_ex_flush;
    logic c_ex_mm_stall;
    logic c_ex_mm_flush;
    logic c_mm_wb_stall;
    logic c_mm_wb_flush;
    logic c_pc_stall   ;
    logic c_pc_flush   ;
    
    logic         f_stall             ;
    logic         f_forward_id_rs     ;
    logic `W_DATA f_forward_id_rs_data;
    logic         f_forward_id_rt     ;
    logic `W_DATA f_forward_id_rt_data;
    logic         f_forward_ex_rs     ;
    logic `W_DATA f_forward_ex_rs_data;
    logic         f_forward_ex_rt     ;
    logic `W_DATA f_forward_ex_rt_data;
    
    // 不经过流水线寄存器的转接信号定义
    
    logic         id_branch     ;
    logic `W_ADDR id_branch_addr;
    logic         ex_alu_stall  ;
    logic         mm_except     ;
    logic `W_ADDR mm_except_addr;
    
    logic ibus_en;
    logic dbus_en;
    logic dbus_vd;
    
    // 流水线间寄存器
    
    typedef struct packed {
        logic `W_ADDR pc        ;
        logic         slot      ;
        bus_error     ibus_error;
    } if_id_packet;
    
    typedef struct packed {
        logic `W_ADDR pc        ;
        logic         slot      ;
        logic `W_TYPE ityp      ;
        logic `W_OPER oper      ;
        logic `W_FUNC func      ;
        logic `W_DATA imme      ;
        logic `W_REGF rs_regf   ;
        logic `W_DATA rs_data   ;
        logic `W_REGF rt_regf   ;
        logic `W_DATA rt_data   ;
        logic `W_REGF rd_regf   ;
        logic `W_INTV intr_vect ;
        logic         sy        ;
        logic         bp        ;
        logic         ri        ;
        logic         er        ;
        logic `W_ADDR er_epc    ;
        bus_error     ibus_error;
    } id_ex_packet;
    
    typedef struct packed {
        logic `W_ADDR pc         ;
        logic         slot       ;
        logic `W_OPER oper       ;
        logic `W_REGF rd_regf    ;
        logic `W_ADDR source_addr;
        logic `W_DATA source_data;
        exe_error     exec_error ;
        bus_error     ibus_error ;
    } ex_mm_packet;
    
    typedef struct packed {
        logic `W_ADDR pc         ;
        logic `W_OPER oper       ;
        logic `W_REGF rd_regf    ;
        logic `W_DATA source_addr;
    } mm_wb_packet;
    
    if_id_packet if_id_i;
    if_id_packet if_id_o;
    id_ex_packet id_ex_i;
    id_ex_packet id_ex_o;
    ex_mm_packet ex_mm_i;
    ex_mm_packet ex_mm_o;
    mm_wb_packet mm_wb_i;
    mm_wb_packet mm_wb_o;
    
    pipeline #(if_id_packet) if_id_(.clk(clk), .rst(rst), .stall(c_if_id_stall), .flush(c_if_id_flush), .data_i(if_id_i), .data_o(if_id_o));
    pipeline #(id_ex_packet) id_ex_(.clk(clk), .rst(rst), .stall(c_id_ex_stall), .flush(c_id_ex_flush), .data_i(id_ex_i), .data_o(id_ex_o));
    pipeline #(ex_mm_packet) ex_mm_(.clk(clk), .rst(rst), .stall(c_ex_mm_stall), .flush(c_ex_mm_flush), .data_i(ex_mm_i), .data_o(ex_mm_o));
    pipeline #(mm_wb_packet) mm_wb_(.clk(clk), .rst(rst), .stall(c_mm_wb_stall), .flush(c_mm_wb_flush), .data_i(mm_wb_i), .data_o(mm_wb_o));
    
    assign if_id_i.ibus_error = ibus_error;
    
    assign id_ex_i.pc         = if_id_o.pc;
    assign id_ex_i.slot       = if_id_o.slot;
    assign id_ex_i.rs_data    = rs.data;
    assign id_ex_i.rt_data    = rt.data;
    assign id_ex_i.intr_vect  = intr_vect;
    assign id_ex_i.er_epc     = er_epc;
    assign id_ex_i.ibus_error = if_id_o.ibus_error;
    
    assign ex_mm_i.pc          = id_ex_o.pc;
    assign ex_mm_i.slot        = id_ex_o.slot;
    assign ex_mm_i.oper        = id_ex_o.oper;
    assign ex_mm_i.rd_regf     = id_ex_o.rd_regf;
    assign ex_mm_i.ibus_error  = id_ex_o.ibus_error;
    
    assign ex_mm_i.exec_error.intr_vect = id_ex_o.intr_vect;
    assign ex_mm_i.exec_error.sy        = id_ex_o.sy;
    assign ex_mm_i.exec_error.bp        = id_ex_o.bp;
    assign ex_mm_i.exec_error.ri        = id_ex_o.ri;
    assign ex_mm_i.exec_error.er        = id_ex_o.er;
    assign ex_mm_i.exec_error.er_epc    = id_ex_o.er_epc;
    
    assign mm_wb_i.pc          = ex_mm_o.pc;
    assign mm_wb_i.oper        = ex_mm_o.oper;
    assign mm_wb_i.rd_regf     = ex_mm_o.rd_regf;
    assign mm_wb_i.source_addr = ex_mm_o.source_addr;
    
    // 模块实例化
    
    if_ if__(
        .clk        (clk           ),
        .rst        (rst           ),
        .stall      (c_pc_stall    ),
        .except     (mm_except     ),
        .except_addr(mm_except_addr),
        .branch     (id_branch     ),
        .branch_addr(id_branch_addr),
        .pc         (if_id_i.pc    ));
    
    // FIXME
    logic `W_DATA flushed_inst;
    assign        flushed_inst = if_id_o.pc == 32'h0 ? 32'h0 : ibus_sbus.data_r;
    
    
    id id_(
        .pc             (if_id_o.pc          ),
        .inst           (flushed_inst        ),
        .rs_data        (rs.data             ),
        .rt_data        (rt.data             ),
        .forward_rs     (f_forward_id_rs     ),
        .forward_rs_data(f_forward_id_rs_data),
        .forward_rt     (f_forward_id_rt     ),
        .forward_rt_data(f_forward_id_rt_data),
        .ityp           (id_ex_i.ityp        ),
        .oper           (id_ex_i.oper        ),
        .func           (id_ex_i.func        ),
        .imme           (id_ex_i.imme        ),
        .rs_regf        (id_ex_i.rs_regf     ),
        .rt_regf        (id_ex_i.rt_regf     ),
        .rd_regf        (id_ex_i.rd_regf     ),
        .branch         (id_branch           ),
        .branch_addr    (id_branch_addr      ),
        .sy             (id_ex_i.sy          ),
        .bp             (id_ex_i.bp          ),
        .ri             (id_ex_i.ri          ),
        .er             (id_ex_i.er          ));
    
    assign if_id_i.slot = `IS_OPER_JB(id_ex_i.oper); // 添加延迟槽标记
    
    ex ex_(
        .clk            (clk                   ),
        .rst            (rst                   ),
        .reg_stall      (c_id_ex_stall         ),
        .reg_flush      (c_id_ex_flush         ),
        .alu_stall      (ex_alu_stall          ),
        .ityp           (id_ex_o.ityp          ),
        .oper           (id_ex_o.oper          ),
        .func           (id_ex_o.func          ),
        .imme           (id_ex_o.imme          ),
        .forward_rs     (f_forward_ex_rs       ),
        .forward_rs_data(f_forward_ex_rs_data  ),
        .forward_rt     (f_forward_ex_rt       ),
        .forward_rt_data(f_forward_ex_rt_data  ),
        .rs_data        (id_ex_o.rs_data       ),
        .rt_data        (id_ex_o.rt_data       ),
        .cp0_rt_data    (cp0_rt.data           ),
        .cp0_rd_data    (cp0_rd.data           ),
        .result         (ex_mm_i.source_addr   ),
        .source_data    (ex_mm_i.source_data   ),
        .ov             (ex_mm_i.exec_error.ov));
    
    mm mm_(
        .pc         (ex_mm_o.pc         ),
        .oper       (ex_mm_o.oper       ),
        .slot       (ex_mm_o.slot       ),
        .ibus_error (ex_mm_o.ibus_error ),
        .dbus_error (dbus_error         ),
        .exec_error (ex_mm_o.exec_error ),
        .cp0w_error (cp0w_error         ),
        .except     (mm_except          ),
        .except_addr(mm_except_addr     ),
        .source_addr(ex_mm_o.source_addr),
        .source_data(ex_mm_o.source_data),
        .dbus_en    (dbus_vd            ),
        .dbus_we    (dbus_sbus.we       ),
        .dbus_size  (dbus_sbus.size     ),
        .dbus_addr  (dbus_sbus.addr     ),
        .dbus_data  (dbus_sbus.data_w   ));
    
    wb wb_(
        .oper       (mm_wb_o.oper       ),
        .rd_regf    (mm_wb_o.rd_regf    ),
        .rd_data_a  (mm_wb_o.source_addr),
        .rd_data_b  (dbus_sbus.data_r   ),
        .pc         (mm_wb_o.pc         ),
        .rd         (rd                 ));
    
    control control_(
        .ibus       (ibus_sbus.stall),
        .dbus       (dbus_sbus.stall),
        .forward    (f_stall        ),
        .mulalu     (ex_alu_stall   ),
        .except     (mm_except      ),
        .if_id_stall(c_if_id_stall  ),
        .if_id_flush(c_if_id_flush  ),
        .id_ex_stall(c_id_ex_stall  ),
        .id_ex_flush(c_id_ex_flush  ),
        .ex_mm_stall(c_ex_mm_stall  ),
        .ex_mm_flush(c_ex_mm_flush  ),
        .mm_wb_stall(c_mm_wb_stall  ),
        .mm_wb_flush(c_mm_wb_flush  ),
        .pc_stall   (c_pc_stall     ),
        .pc_flush   (c_pc_flush     ));
    
    forward forward_(
        .oper_id           (id_ex_i.oper        ),
        .oper_ex           (id_ex_o.oper        ),
        .from_ex_regf      (id_ex_o.rd_regf     ),
        .from_ex_data      (ex_mm_i.source_addr ),
        .from_mm_regf      (ex_mm_o.rd_regf     ),
        .from_mm_data      (dbus_sbus.data_w    ),
        .from_wb_regf      (mm_wb_o.rd_regf     ),
        .from_wb_data      (rd.data             ),
        .into_id_rs        (id_ex_i.rs_regf     ),
        .into_id_rt        (id_ex_i.rt_regf     ),
        .into_ex_rs        (id_ex_o.rs_regf     ),
        .into_ex_rt        (id_ex_o.rt_regf     ),
        .stall             (f_stall             ),
        .forward_id_rs     (f_forward_id_rs     ),
        .forward_id_rs_data(f_forward_id_rs_data),
        .forward_id_rt     (f_forward_id_rt     ),
        .forward_id_rt_data(f_forward_id_rt_data),
        .forward_ex_rs     (f_forward_ex_rs     ),
        .forward_ex_rs_data(f_forward_ex_rs_data),
        .forward_ex_rt     (f_forward_ex_rt     ),
        .forward_ex_rt_data(f_forward_ex_rt_data));
    
    // 处理剩余总线以及寄存器接口
    
    always @(posedge clk) begin
        ibus_en <= ~   c_pc_stall;
        dbus_en <= ~c_ex_mm_stall;
    end
    
    assign ibus_sbus.en     = (~rst & ibus_en) | mm_except;
    assign ibus_sbus.we     = 1'b0;
    assign ibus_sbus.addr   = if_id_i.pc;
    assign ibus_sbus.size   = 2'b10;
    assign ibus_sbus.data_w = 32'h0;
    
    assign dbus_sbus.en = ~rst & dbus_vd & dbus_en;
    
    assign ibus_update = ~   c_pc_stall;
    assign dbus_update = ~c_mm_wb_stall;
    
    assign cp0_rt.regf =                              id_ex_o.rt_regf;
    assign cp0_rd.regf = id_ex_o.oper == `OPER_MTC0 ? id_ex_o.rd_regf : 0;
    
    assign rs.regf = id_ex_i.rs_regf;
    assign rt.regf = id_ex_i.rt_regf;
    
    // 处理调试信息：在停顿和刷新时不进行输出
    
    logic debug_enable;
    
    pipeline #(logic) if_id_control_(
        .clk  (clk ),
        .rst  (rst ),
        .stall(1'b0),
        .flush(1'b0),
        
        .data_i(~c_mm_wb_stall & ~c_mm_wb_flush),
        .data_o(debug_enable                   ));
    
    assign debug = {mm_wb_o.pc, {4{rd.regf != 0 & debug_enable}}, rd.regf, rd.data};
    
endmodule

