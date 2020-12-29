`timescale 1ns/1ps
`include "defines.vh"

module sim_mulalu();
    
    logic         clk          ;
    logic         rst          ;
    
    logic         reg_stall    ;
    logic         alu_stall    ;
    
    logic `W_OPER oper         ;
    logic `W_FUNC func         ;
    logic `W_DATA source_a     ;
    logic `W_DATA source_b     ;
    logic `W_DATA result       ;

    logic `W_DATA hi           ;
    logic         hi_write     ;
    logic `W_DATA hi_write_data;
    
    logic `W_DATA lo           ;
    logic         lo_write     ;
    logic `W_DATA lo_write_data;
    
    assign reg_stall = alu_stall;
    
    assign hi_write = 1'b0;
    assign lo_write = 1'b0;
    
    initial begin
        clk <= 1'b0;
        rst <= 1'b1;
        oper <= 0;
        func <= 0;
        
        #20
        rst <= 1'b0;
        oper <= `OPER_ALUS;
        func <= `FUNC_DIV;
        source_a <= 19;
        source_b <= -4;
    end
    
    always #10 clk = ~clk;
    
    mulalu mulalu_(.*);
    
endmodule

