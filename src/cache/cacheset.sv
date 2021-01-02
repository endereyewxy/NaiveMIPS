`timescale 1ns/1ps

import includes::*;

module cacheset(
    input  logic         clk    ,
    input  logic         rst    ,
    
    input  logic         rd     ,
    
    input  logic         we     ,
    input  logic         wp     , // 0: 写命中行
                                  // 1: 写替换行
    input  logic         wd     ,
    input  logic `W_CTAG ctag_w ,
    input  logic `W_DATA data_w ,
    
    input  logic `W_CTAG ctag   ,
    
    output logic         hit    ,
    output logic         h_valid,
    output logic `W_DATA h_data ,
    
    output logic         r_dirty,
    output logic `W_CTAG r_ctag ,
    output logic `W_DATA r_data );
    
    logic [3:0] line_we ;
    logic [3:0] line_wd ;
    logic [3:0] line_hit;
    
    logic         line_valid [3:0];
    logic         line_dirty [3:0];
    logic `W_CTAG line_ctag  [3:0];
    logic `W_DATA line_data  [3:0];
    
    generate
        for (genvar i = 0; i < 4; i = i + 1) begin : generate_cacheline
            cacheline cacheline_(
                .clk   (clk          ),
                .rst   (rst          ),
                .we    (line_we   [i]),
                .wd    (line_wd   [i]),
                .ctag_w(ctag_w       ),
                .data_w(data_w       ),
                .valid (line_valid[i]),
                .dirty (line_dirty[i]),
                .ctag  (line_ctag [i]),
                .data  (line_data [i]));
            
            assign line_hit[i] = line_valid[i] & (line_ctag[i] == ctag);
        end
    endgenerate
    
    // 选择命中行
    
    logic [3:0] mask;
    assign      mask = line_hit[0] ? 4'b0001 :
                       line_hit[1] ? 4'b0010 :
                       line_hit[2] ? 4'b0100 :
                       line_hit[3] ? 4'b1000 : 4'b0000;
    
    assign hit = line_hit != 4'h0;
    
    always @(*) begin
        case (mask)
            4'b0001: {h_valid, h_data} = {line_valid[0], line_data[0]};
            4'b0010: {h_valid, h_data} = {line_valid[1], line_data[1]};
            4'b0100: {h_valid, h_data} = {line_valid[2], line_data[2]};
            4'b1000: {h_valid, h_data} = {line_valid[3], line_data[3]};
            default: {h_valid, h_data} = 0                            ;
        endcase
    end
    
    // 维护伪LRU树
    
    logic [2:0] lru;
    
    always @(posedge clk) begin
        if (rst) begin
            lru <= 3'h0;
        end else if (rd & hit) begin
            lru <= {mask[0] | mask[1]                    ,
                   (mask[0] | mask[1]) ? mask[0] : lru[1],
                   (mask[2] | mask[3]) ? mask[2] : lru[2]};
        end
    end
    
    // 选择替换行
    
    always @(*) begin
        if (lru[0])
            {r_dirty, r_ctag, r_data} = lru[2] ? {line_dirty[3], line_ctag[3], line_data[3]}
                                               : {line_dirty[2], line_ctag[2], line_data[2]};
        else
            {r_dirty, r_ctag, r_data} = lru[1] ? {line_dirty[1], line_ctag[1], line_data[1]}
                                               : {line_dirty[0], line_ctag[0], line_data[0]};
    end
    
    logic [3:0] line_lru;
    assign      line_lru = lru[0] ? (lru[2] ? 4'b1000 : 4'b0100)
                                  : (lru[1] ? 4'b0010 : 4'b0001);
    
    assign line_we = {4{we}} & (wp ? line_lru : mask);
    assign line_wd = {4{wd}} & (wp ? line_lru : mask);
    
endmodule

