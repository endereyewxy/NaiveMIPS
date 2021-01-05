`timescale 1ns/1ps

import includes::*;

module gpr(
    input        logic clk,
    input        logic rst,
    regf_r.slave       rs ,
    regf_r.slave       rt ,
    regf_w.slave       rd );
    
    reg `W_DATA [31:0] regfile;
    
    always @(negedge clk) begin
        if (rst)
            regfile <= 0;
        else if (rd.we)
            regfile[rd.regf] <= rd.data;
    end
    
    assign rs.data = regfile[rs.regf];
    assign rt.data = regfile[rt.regf];
    
endmodule
