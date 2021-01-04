`timescale 1ns/1ps

import includes::*;

module cache(
    input      logic         clk              ,
    input      logic         rst              ,
    
    input      logic         sbus_update      ,
    input      logic         sbus_en          ,
    input      logic         sbus_we          ,
    input      logic [1:0]   sbus_size        ,
    input      logic `W_ADDR sbus_addr        ,
    input      logic `W_DATA sbus_data_w      ,
    output     logic `W_DATA sbus_data_r      ,
    output     logic         sbus_stall       ,
    
    output     logic         sram_like_req    ,
    output     logic         sram_like_wr     ,
    output     logic [1:0]   sram_like_size   ,
    output     logic `W_ADDR sram_like_addr   ,
    output     logic `W_DATA sram_like_wdata  ,
    input      logic `W_DATA sram_like_rdata  ,
    input      logic         sram_like_addr_ok,
    input      logic         sram_like_data_ok);
    
    localparam OK = 2'b00; // 就绪
    localparam WR = 2'b10; // 正在向内存中写回
    localparam RD = 2'b11; // 正在从内存中替换
    
    logic [1:0] state;
    
    // 实例化缓存组
    
    logic we;
    logic wp;
    logic wm;
    logic wd;
    
    logic         grp_hit    [1:0];
    logic         grp_rep    [1:0];
    logic         grp_need   [1:0];
    logic `W_CTAG grp_ctag   [1:0];
    logic `W_DATA grp_data_r [1:0];
    logic `W_DATA grp_data_w      ;
    
    logic  hit;
    assign hit = grp_hit[0] | grp_hit[1];
    
    generate
        for (genvar i = 0; i < 2; i = i + 1) begin : generate_group
            group group_(
                .clk   (clk          ),
                .rst   (rst          ),
                .addr  (sbus_addr    ),
                .size  (sbus_size    ),
                .hit   (grp_hit[i]   ),
                .rep   (grp_rep[i]   ),
                .we    (we           ),
                .wp    (wp           ),
                .wm    (wm),
                .wd    (wd           ),
                .data_w(grp_data_w   ),
                .need_r(grp_need  [i]),
                .ctag_r(grp_ctag  [i]),
                .data_r(grp_data_r[i]));
        end
    endgenerate
    
    // 使用寄存器维护 LRU 位
    
    logic [`CACHE_DEPTH - 1 : 0] c_lru;
    logic                          lru;
    assign                         lru = c_lru[sbus_addr[11:2]];
    
    assign grp_rep[0] = ~lru;
    assign grp_rep[1] =  lru;
    
    logic         dirty;
    assign        dirty = grp_need[lru];
    logic `W_CTAG rptag;
    assign        rptag = grp_ctag[lru];
    logic `W_DATA wdata;
    assign        wdata = grp_data_r[lru];
    
    always @(posedge clk) begin
        if (rst)
            c_lru <= 0;
        else if (state == OK & sbus_en)
            c_lru[sbus_addr[11:2]] <= hit ? grp_hit[0] : ~c_lru[sbus_addr[11:2]];
    end
    
    // 其它准备工作
    
    logic  need_wr;
    assign need_wr = ~hit & dirty;
    logic  need_rd;
    assign need_rd = ~hit & ~sbus_we;
    
    // 状态机逻辑
    
    always @(posedge clk) begin
        if (rst) begin
            state <= OK;
        end else begin
            case (state)
                OK: if (sbus_en)
                        state <= need_wr ? WR :
                                 need_rd ? RD : OK;
                WR: if (sram_like_data_ok)
                        state <= need_rd ? RD : OK;
                RD: if (sram_like_data_ok)
                        state <=                OK;
            endcase
        end
    end
    
    // 处理缓存组的写逻辑
    
    logic  we_mem;
    assign we_mem =  state == RD & sram_like_data_ok;                       // 从内存中加载数据
    logic  we_dir;
    assign we_dir =  state == OK & sbus_en & sbus_we & hit;                 // 直接写命中
    logic  we_new;
    assign we_new = (state == OK & sbus_en & sbus_we & ~hit & ~dirty    ) | // 写未命中但无需写回
                    (state == WR &           sbus_we & sram_like_data_ok) ; // 写未命中，写回完成之后
    
    assign we = we_mem | we_dir | we_new;
    assign wp = we_mem | we_new;
    assign wm = we_mem         ;
    assign wd = we_dir | we_new;
    
    assign grp_data_w = we_mem ? sram_like_rdata : sbus_data_w;
    
    // 处理缓存组的读逻辑
    
    
    logic         data_update;
    logic `W_DATA data_stored;
    logic `W_DATA data_pushed;
    assign        data_update = (state == OK & sbus_en & ~sbus_we & hit) | // 读直接命中
                                (state == RD & sram_like_data_ok       ) ; // 完成替换时
    assign        data_pushed =  state == OK ? grp_data_r[grp_hit[1]] : sram_like_rdata;
    logic `W_DATA data_tosbus;
    assign        data_tosbus = sbus_addr[1:0] == 2'b00 ?         data_pushed         :
                                sbus_addr[1:0] == 2'b01 ? { 8'h0, data_pushed[31: 8]} :
                                sbus_addr[1:0] == 2'b10 ? {16'h0, data_pushed[31:16]} :
                                                          {24'h0, data_pushed[31:24]} ;
    
    always @(posedge clk)
        if (rst) data_stored <= 0; else if (data_update) data_stored <= data_tosbus;
    
    
    always @(posedge clk)
        if (sbus_update) sbus_data_r <= data_update ? data_tosbus : data_stored;
    
    // 处理停顿逻辑
    
    assign sbus_stall = (state == OK & sbus_en & (need_wr | need_rd)) | // 需要写回或者替换
                        (state == WR                                ) | // 正在写回
                        (state == RD &           ~sram_like_data_ok ) ; // 还没有替换完成
    
    // 处理 SRAM-LIKE 接口请求时序
    
    logic  sbus_posedge;
    assign sbus_posedge = (state == OK & sbus_en & (need_wr | need_rd)) | // OK -> WR, OK -> RD
                          (state == WR & sram_like_data_ok &  need_rd ) ; // WR -> RD
    
    logic req;
    
    always @(posedge clk)
        if (rst | sram_like_addr_ok) req <= 1'b0; else if (sbus_posedge) req <= 1'b1;
    
    assign sram_like_req = sbus_posedge | req;
    
    // 连接总线接口
    
    assign sram_like_wr    = (state == OK & need_wr) | (state == WR & req);
    assign sram_like_size  = 2'b10;
    assign sram_like_addr  = sram_like_wr ? {rptag, sbus_addr[11:2], 2'b00} : {sbus_addr[31:2], 2'b00};
    assign sram_like_wdata = wdata;
    
endmodule

