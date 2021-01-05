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
            regfile     <= 0           ;
            regfile[12] <= 32'h0000ff01;
            regfile[16] <= 32'h00000800;
        end else begin
            regfile[ 9]          <= regfile[ 9] + 32'h1;
            regfile[13][15:10]   <= hard_intr;
            if (cp0w.we) begin
                regfile[13][31 ] <= cp0w.bd ;
                regfile[12][1  ] <= cp0w.exl;
                regfile[13][6:2] <= cp0w.exc;
                regfile[14]      <= cp0w.epc;
                regfile[ 8]      <= cp0w.bva;
            end else if (rd.we) begin
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
    
    always @(*) begin
        rt.data = (rd.we & rt.regf == rd.regf) ? rd.data : regfile[rt.regf];
        if (cp0w.we) begin
            case (rt.regf)
                8 : rt.data = cp0w.bva;
                14: rt.data = cp0w.epc;
                12: rt.data = {regfile[12][31:2], cp0w.exl, regfile[12][0]};
                13: rt.data = {cp0w.bd, regfile[13][30:7], cp0w.exc, regfile[13][1:0]};
            endcase
        end
    end
    
endmodule

