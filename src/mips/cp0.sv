`timescale 1ns / 1ps
`include"defines.vh"

module cpo(
    input  logic         clk       ,
    input  logic         rst       ,
    input  logic         cp0_en    ,
    input  logic         cp0_bd    ,
    input  logic         cp0_exl   ,
    input  logic `W_EXCC cp0_exc   ,
    input  logic `W_ADDR cp0_epc   ,
    input  logic `W_ADDR cp0_bva   ,
    input  logic `W_REGF regf_w    ,
    input  logic `W_REGF regf_r    ,
    input  logic `W_DATA data_w    ,
    output logic `W_DATA data_r    ,
    output logic `W_INTV intr_vect);

    integer i=0;
    reg `W_DATA REGF_CP0[31:0]     ; 
    assign BadVAddr =   CP0[8]     ;
    assign Status   =   CP0[12]    ;
    assign Cause    =   CP0[13]    ;
    assign EPC      =   CP0[14]    ;
    initial
    begin
        for(i=0;i<32;i=i+1)
        REGF_CP0[i]=0;
    end
    always @(posedge clk)
    begin
        if(rst)
        begin
            for(i=0;i<32;i=i+1)
            REGF_CP0[i]=0; 
        end
        if(cp0_en)
        begin
            Status[1] <=cp0_exl;
            Cause[6:2]<=cp0_exc;
            Cause[31] <=cp0_bd ;
            EPC       <=cp0_exc;
            BadVAddr  <=cp0_bva;
            if(regf_w!=0)
                CP0[regf_w]<=data_w;
        end
        if(regf_r!=0)
            CP0[regf_r]<=data_r;
        assign intr_vect = Cause[15:7];
    end
endmodule