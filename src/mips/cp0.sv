`timescale 1ns/1ps

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
            regfile[0 ] <= 0           ;
            regfile[12] <= 32'h0000ff01;
            regfile[13] <= 0           ;
            regfile[13][ 9: 0] <= 0    ;
        end else begin
            regfile[13][15:10]   <= hard_intr;
            if (cp0w.we) begin
                regfile[13][31 ] <= cp0w.bd ;
                regfile[12][1  ] <= cp0w.exl;
                regfile[13][6:2] <= cp0w.exc;
                regfile[14]      <= cp0w.epc;
                regfile[ 8]      <= cp0w.bva;
            end else if (rd.regf != 0) begin
                regfile[rd.regf] <= rd.data ;
            end
        end
    end
    
    logic `W_DATA through12;
    logic `W_DATA through13;
    logic `W_DATA through14;
    
    assign through12 = (rd.regf == 12) ? rd.data : regfile[12];
    assign through13 = (rd.regf == 13) ? rd.data : regfile[13];
    assign through14 = (rd.regf == 14) ? rd.data : regfile[14];
    
    assign intr_vect = (through13[15:8] & through12[15:8]) & {8{~(cp0w.we ? cp0w.exl : through12[1])}} & {8{through12[0]}};
    
    assign er_epc    = cp0w.we ? cp0w.epc : through14;
    
    assign rt.data =
            (cp0w.we & rt.regf ==  8          ) ? cp0w.bva                                                 :
            (cp0w.we & rt.regf == 14          ) ? cp0w.epc                                                 :
            (cp0w.we & rt.regf == 12          ) ? {regfile[12][31:2], cp0w.exl, regfile[12][0]}            :
            (cp0w.we & rt.regf == 13          ) ? {cp0w.bd, regfile[13][30:7], cp0w.exc, regfile[13][1:0]} :
            (rt.regf == rd.regf & rd.regf != 0) ? rd.data                                                  : regfile[rt.regf];
    
endmodule

