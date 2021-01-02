`timescale 1ns/1ps

import includes::*;

module cacheline(
    input  logic         clk   ,
    input  logic         rst   ,
    
    input  logic         we    ,
    input  logic         wd    ,
    input  logic `W_CTAG ctag_w,
    input  logic `W_DATA data_w,
    
    output logic         valid ,
    output logic         dirty ,
    output logic `W_CTAG ctag  ,
    output logic `W_DATA data  );
    
    always @(posedge clk) begin
        if (rst) begin
            valid <= 1'b0;
            dirty <= 1'b0;
            ctag  <= 0   ;
            data  <= 0   ;
        end else if (we) begin
            valid <= 1'b1  ;
            dirty <= wd    ;
            ctag  <= ctag_w;
            data  <= data_w;
        end
    end
    
endmodule

