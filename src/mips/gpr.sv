`timescale 1ns/1ps

import includes::*;

module gpr(
    input        logic clk,
    input        logic rst,
    regf_r.slave       rs ,
    regf_r.slave       rt ,
    regf_w.slave       rd );
    
    reg `W_DATA [31:0] regfile;
    
    always @(posedge clk) begin
        if(rst) begin
            regfile <= 0;
        end else if (rd.regf != 0) begin
            regfile[rd.regf] <= rd.data;
        end
    end
    
    assign rs.data = (rs.regf == rd.regf & rd.regf != 0) ? rd.data : regfile[rs.regf];
    assign rt.data = (rt.regf == rd.regf & rd.regf != 0) ? rd.data : regfile[rt.regf];
    
endmodule
