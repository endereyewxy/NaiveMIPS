`timescale 1ns/1ps
`include "defines.vh"

module gpr(
    input        logic clk,
    input        logic rst,
    regf_r.slave       rs ,
    regf_r.slave       rt ,
    regf_w.slave       rd );
    
    reg `W_DATA regfile[31:0];
    
    always @(posedge clk) begin
        if(rst) begin
            regfile[0] <= 0;
        end else if (rd.regf != 0) begin
            regfile[rd.regf] <= rd.data;
        end
    end
    
    assign rs.data = regfile[rs.regf];
    assign rt.data = regfile[rt.regf];
    
endmodule
