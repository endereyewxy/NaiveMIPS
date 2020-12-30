`timescale 1ns/1ps
`include "defines.vh"

module cpo(
    input        logic         clk       ,
    input        logic         rst       ,
    regf_r.slave               rt        ,
    regf_w.slave               rd        ,
    input        reg_error     cp0w      ,
    output       logic `W_INTV intr_vect ,
    output       logic `W_ADDR er_epc    );
    
    reg `W_DATA [31:0] regfile;
    
    logic `W_DATA BadVAddr;
    logic `W_DATA Status  ;
    logic `W_DATA Cause   ;
    logic `W_DATA EPC     ;
    
    always @(posedge clk) begin
        if (rst) begin
            regfile <= 0;
        end else if (cp0w.we) begin
            Cause   [31 ] <= cp0w.bd ;
            Status  [1  ] <= cp0w.exl;
            Cause   [6:2] <= cp0w.exc;
            EPC           <= cp0w.epc;
            BadVAddr      <= cp0w.bva;
        end else if (rd.regf != 0) begin
            regfile[rd.regf] <= rd.data;
        end
    end
    
    assign intr_vect = (Cause[15:8] & Status[15:8]) & {8{Status[1]}};
    assign er_epc    = EPC;
    
    assign rt.data = regfile[rt.regf];
    
endmodule

