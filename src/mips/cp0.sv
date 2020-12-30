`timescale 1ns/1ps
`include "defines.vh"

import includes::*;

module cp0(
    input        logic         clk      ,
    input        logic         rst      ,
    regf_r.slave               rt       ,
    regf_w.slave               rd       ,
    input        reg_error     cp0w     ,
    input        logic `W_HINT hard_intr,
    output       logic `W_INTV intr_vect,
    output       logic `W_ADDR er_epc   );
    
    reg `W_DATA [31:0] regfile;
    
    always @(posedge clk) begin
        if (rst) begin
            regfile <= 0;
        end else if (cp0w.we) begin
            regfile[13][31 ] <= cp0w.bd ;
            regfile[12][1  ] <= cp0w.exl;
            regfile[13][6:2] <= cp0w.exc;
            regfile[14]      <= cp0w.epc;
            regfile[ 8]      <= cp0w.bva;
        end else if (rd.regf != 0) begin
            regfile[rd.regf] <= rd.data;
        end
    end
    
    always @(posedge clk) regfile[13][15:10] <= hard_intr;
    
    assign intr_vect = (regfile[13][15:8] & regfile[12][15:8]) & {8{regfile[12][1]}};
    assign er_epc    =  regfile[14];
    
    assign rt.data =
            (cp0w.we & rt.regf ==  8          ) ? cp0w.bva                                                 :
            (cp0w.we & rt.regf == 14          ) ? cp0w.epc                                                 :
            (cp0w.we & rt.regf == 12          ) ? {regfile[12][31:2], cp0w.exl, regfile[12][0]}            :
            (cp0w.we & rt.regf == 13          ) ? {cp0w.bd, regfile[13][30:7], cp0w.exc, regfile[13][1:0]} :
            (rt.regf == rd.regf & rd.regf != 0) ? rd.data                                                  : regfile[rt.regf];
    
endmodule

