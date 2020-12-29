`timescale 1ns / 1ps
`include"defines.vh"

module gpr(
    input  logic         clk    ,
    input  logic         rst    ,
    input  logic `W_REGF rs_regf,
    output logic `W_DATA rs_data,
    input  logic `W_REGF rt_regf,
    output logic `W_DATA rt_data,
    input  logic `W_REGF rd_regf,
    input  logic `W_DATA rd_data);
    

    integer i=0;
    reg `W_DATA REG_Files[31:0];
    initial
    begin
        for(i=0;i<32;i=i+1)
        REG_Files[i]=0;
    end
    always @(posedge clk)
    begin
        if(rst)
            for(i=0;i<32;i=i+1)
            REG_Files[i]=0;
        if(rd_regf)
        REG_Files[rd_regf] <= rd_data;
    end

    assign rs_data = REG_Files[rs_regf];
    assign rt_data = REG_Files[rt_regf];

endmodule
