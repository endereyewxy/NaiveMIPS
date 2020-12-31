`timescale 1ns/1ps

import includes::*;

module datapath(
    input       logic         clk       ,
    input       logic         rst       ,
    input       logic `W_INTV intr_vect ,  // ID
    input       logic `W_ADDR er_epc    ,  // ID
    sbus.master               ibus_sbus ,  // IF - ID
    sbus.master               dbus_sbus ,  // MM - WB
    output      reg_error     cp0w_error,  // MM
    regf_r.master             cp0_rt    ,  // EX
    regf_w.master             cp0_rd    ,  // EX
    regf_r.master             rs        ,  // ID
    regf_r.master             rt        ,  // ID
    regf_w.master             rd        ,  // WB
    output      debuginfo     debug     );
    
    typedef struct packed {
        logic         ibus_e ;
        logic         slot   ;
        logic `W_OPER oper   ;
        logic `W_ADDR pc     ;
        logic `W_REGF rd_regf;
    } pipeinfo; // 贯穿整条流水线的信息
    
    // 信号定义
    
    // IF
    
    logic `W_ADDR if_pc  ;
    logic         if_slot;
    
    // ID
    
    logic         id_if_id_flush;
    logic `W_TYPE id_ityp       ;
    logic `W_FUNC id_func       ;
    logic `W_DATA id_imme       ;
    logic `W_REGF id_rs_regf    ;
    logic `W_REGF id_rt_regf    ;
    logic         id_branch     ;
    logic `W_ADDR id_branch_addr;
    logic         id_sy         ;
    logic         id_bp         ;
    logic         id_ri         ;
    logic         id_er         ;
    pipeinfo      id_pipeinfo   ;
    
    // EX
    
    logic         ex_alu_stall  ;
    logic `W_TYPE ex_ityp       ;
    logic `W_FUNC ex_func       ;
    logic `W_DATA ex_imme       ;
    logic `W_REGF ex_rs_regf    ;
    logic `W_REGF ex_rt_regf    ;
    logic `W_DATA ex_rs_data    ;
    logic `W_DATA ex_rt_data    ;
    logic `W_DATA ex_result     ;
    logic `W_DATA ex_source_data;
    pipeinfo      ex_pipeinfo   ;
    exe_error     ex_exec_error ;
    
    // MM
    
    logic         mm_except     ;
    logic `W_ADDR mm_except_addr;
    logic `W_ADDR mm_source_addr;
    logic `W_DATA mm_source_data;
    pipeinfo      mm_pipeinfo   ;
    exe_error     mm_exec_error ;
    
    // WB
    
    logic `W_DATA wb_rd_data_a;
    pipeinfo      wb_pipeinfo ;
    
    // control
    
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
    
    // forward
    
    logic         f_stall             ;
    logic         f_forward_id_rs     ;
    logic `W_DATA f_forward_id_rs_data;
    logic         f_forward_id_rt     ;
    logic `W_DATA f_forward_id_rt_data;
    logic         f_forward_ex_rs     ;
    logic `W_DATA f_forward_ex_rs_data;
    logic         f_forward_ex_rt     ;
    logic `W_DATA f_forward_ex_rt_data;
    
    // 处理访存异常
    
    bus_error dbus_error;
    
    logic ibus_e;
    logic dbus_e;
    
    assign ibus_e = ((ibus_sbus.size == 2'b01 & ibus_sbus.addr[  0] != 0) |
                     (ibus_sbus.size == 2'b10 & ibus_sbus.addr[1:0] != 0) ) & ibus_sbus.en;
    assign dbus_e = ((dbus_sbus.size == 2'b01 & dbus_sbus.addr[  0] != 0) |
                     (dbus_sbus.size == 2'b10 & dbus_sbus.addr[1:0] != 0) ) & dbus_sbus.en;
    
    assign dbus_error.adel = dbus_e & ~dbus_sbus.we;
    assign dbus_error.ades = dbus_e &  dbus_sbus.we;
    assign dbus_error.addr = dbus_sbus.addr;
    
    // 流水线间寄存器
    
    // 特殊：不会刷新的寄存器，用于传递IF-ID刷新控制信号
    
    pipeline #(1) if_id_control_(
        .clk  (clk ),
        .rst  (rst ),
        .stall(1'b0),
        .flush(1'b0),
        
        .data_i( c_if_id_flush),
        .data_o(id_if_id_flush));
    
    pipeline #(34) if_id_(
        .clk  (clk          ),
        .rst  (rst          ),
        .stall(c_if_id_stall),
        .flush(c_if_id_flush),
        
        .data_i({if_pc         , if_slot         ,             ibus_e}),
        .data_o({id_pipeinfo.pc, id_pipeinfo.slot, id_pipeinfo.ibus_e}));
    
    pipeline #(200) id_ex_(
        .clk  (clk          ),
        .rst  (rst          ),
        .stall(c_id_ex_stall),
        .flush(c_id_ex_flush),
        
        .data_i({id_ityp, id_func, id_imme, id_rs_regf, id_rt_regf, rs.data   , rt.data   , id_pipeinfo, intr_vect              , id_sy           , id_bp           , id_ri           , id_er           , er_epc              }),
        .data_o({ex_ityp, ex_func, ex_imme, ex_rs_regf, ex_rt_regf, ex_rs_data, ex_rt_data, ex_pipeinfo, ex_exec_error.intr_vect, ex_exec_error.sy, ex_exec_error.bp, ex_exec_error.ri, ex_exec_error.er, ex_exec_error.er_epc}));
    
    pipeline #(153) ex_mm_(
        .clk  (clk          ),
        .rst  (rst          ),
        .stall(c_ex_mm_stall),
        .flush(c_ex_mm_flush),
        
        .data_i({ex_pipeinfo, ex_exec_error, ex_result     , ex_source_data}),
        .data_o({mm_pipeinfo, mm_exec_error, mm_source_addr, mm_source_data}));
    
    pipeline #(78) mm_wb_(
        .clk  (clk          ),
        .rst  (rst          ),
        .stall(c_mm_wb_stall),
        .flush(c_mm_wb_flush),
        
        .data_i({mm_pipeinfo, dbus_sbus.data_w, mm_word_offset}),
        .data_o({wb_pipeinfo, wb_rd_data_a    , wb_word_offset}));
    
    // 模块实例化
    
    // IF
    
    if_ if__(
        .clk        (clk           ),
        .rst        (rst           ),
        .stall      (c_pc_stall    ),
        .except     (mm_except     ),
        .except_addr(mm_except_addr),
        .branch     (id_branch     ),
        .branch_addr(id_branch_addr),
        .pc         (ibus_sbus.en  ),
        .pc_addr    (if_pc         ));
    
    assign ibus_sbus.we   = 0;
    assign ibus_sbus.size = 2'b10;
    assign ibus_sbus.addr = if_pc;
    
    // ID
    
    // 防止指令为X；刷新IF-ID时也刷新指令
    logic `W_DATA no_x_inst;
    
    assign no_x_inst = (ibus_sbus.data_r[0] === 1'bx | id_if_id_flush) ? 32'h0 : ibus_sbus.data_r;
    
    id id_(
        .pc             (id_pipeinfo.pc      ),
        .inst           (no_x_inst           ),
        .rs_data        (rs.data             ),
        .rt_data        (rt.data             ),
        .forward_rs     (f_forward_id_rs     ),
        .forward_rs_data(f_forward_id_rs_data),
        .forward_rt     (f_forward_id_rt     ),
        .forward_rt_data(f_forward_id_rt_data),
        .ityp           (id_ityp             ),
        .oper           (id_pipeinfo.oper    ),
        .func           (id_func             ),
        .imme           (id_imme             ),
        .rs_regf        (id_rs_regf          ),
        .rt_regf        (id_rt_regf          ),
        .rd_regf        (id_pipeinfo.rd_regf ),
        .branch         (id_branch           ),
        .branch_addr    (id_branch_addr      ),
        .sy             (id_sy               ),
        .bp             (id_bp               ),
        .ri             (id_ri               ),
        .er             (id_er               ));
    
    // 添加延迟槽标记
    assign if_slot = `IS_OPER_JB(id_pipeinfo.oper);
    
    assign rs.regf = id_rs_regf;
    assign rt.regf = id_rt_regf;
    
    // EX
    
    ex ex_(
        .clk            (clk                 ),
        .rst            (rst                 ),
        .reg_stall      (c_id_ex_stall       ),
        .reg_flush      (c_id_ex_flush       ),
        .alu_stall      (ex_alu_stall        ),
        .ityp           (ex_ityp             ),
        .oper           (ex_pipeinfo.oper    ),
        .func           (ex_func             ),
        .imme           (ex_imme             ),
        .forward_rs     (f_forward_ex_rs     ),
        .forward_rs_data(f_forward_ex_rs_data),
        .forward_rt     (f_forward_ex_rt     ),
        .forward_rt_data(f_forward_ex_rt_data),
        .rs_data        (ex_rs_data          ),
        .rt_data        (ex_rt_data          ),
        .cp0_rt_data    (cp0_rt.data         ),
        .cp0_rd_data    (cp0_rd.data         ),
        .result         (ex_result           ),
        .ov             (ex_exec_error.ov    ),
        .source_data    (ex_source_data      ));
    
    assign cp0_rt.regf = ex_rt_regf;
    assign cp0_rd.regf = ex_pipeinfo.oper == `OPER_MTC0 ? ex_pipeinfo.rd_regf : 0;
    
    // MM
    
    bus_error ibus_error;
    
    assign ibus_error.adel = mm_pipeinfo.ibus_e;
    assign ibus_error.ades = 1'b0;
    assign ibus_error.addr = mm_pipeinfo.pc;
    
    mm mm_(
        .oper       (mm_pipeinfo.oper),
        .slot       (mm_pipeinfo.slot),
        .pc         (mm_pipeinfo.pc  ),
        .ibus_error (ibus_error      ),
        .dbus_error (dbus_error      ),
        .exec_error (mm_exec_error   ),
        .cp0w_error (cp0w_error      ),
        .except     (mm_except       ),
        .except_addr(mm_except_addr  ),
        .source_addr(mm_source_addr  ),
        .source_data(mm_source_data  ),
        .dbus_en    (dbus_sbus.en    ),
        .dbus_we    (dbus_sbus.we    ),
        .dbus_size  (dbus_sbus.size  ),
        .dbus_addr  (dbus_sbus.addr  ),
        .dbus_data  (dbus_sbus.data_w));
    
    // WB
    
    wb wb_(
        .oper       (wb_pipeinfo.oper   ),
        .rd_regf    (wb_pipeinfo.rd_regf),
        .rd_data_a  (wb_rd_data_a       ),
        .rd_data_b  (dbus_sbus.data_r   ),
        .pc         (wb_pipeinfo.pc     ),
        .rd         (rd                 ));
    
    // control
    
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
    
    // forward
    
    forward forward_(
        .oper_id           (id_pipeinfo.oper    ),
        .oper_ex           (ex_pipeinfo.oper    ),
        .from_ex_regf      (ex_pipeinfo.rd_regf ),
        .from_ex_data      (ex_result           ),
        .from_mm_regf      (mm_pipeinfo.rd_regf ),
        .from_mm_data      (dbus_sbus.data_w    ),
        .from_wb_regf      (wb_pipeinfo.rd_regf ),
        .from_wb_data      (rd.data             ),
        .into_id_rs        (id_rs_regf          ),
        .into_id_rt        (id_rt_regf          ),
        .into_ex_rs        (ex_rs_regf          ),
        .into_ex_rt        (ex_rt_regf          ),
        .stall             (f_stall             ),
        .forward_id_rs     (f_forward_id_rs     ),
        .forward_id_rs_data(f_forward_id_rs_data),
        .forward_id_rt     (f_forward_id_rt     ),
        .forward_id_rt_data(f_forward_id_rt_data),
        .forward_ex_rs     (f_forward_ex_rs     ),
        .forward_ex_rs_data(f_forward_ex_rs_data),
        .forward_ex_rt     (f_forward_ex_rt     ),
        .forward_ex_rt_data(f_forward_ex_rt_data));
    
    assign debug = {wb_pipeinfo.pc, (rd.regf == 0) ? 4'b0000 : 4'b1111, rd.regf, rd.data};
    
endmodule

