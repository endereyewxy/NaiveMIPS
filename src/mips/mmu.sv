`timescale 1ns / 1ps
`include"defines.vh"

module mmu(
    input  logic `W_ADDR instr_v_addr,
    input  logic `W_ADDR data_v_addr ,
    output logic `W_ADDR instr_p_addr,
    output logic `W_ADDR data_p_addr ,
    output logic         no_dcache   );

    logic inst_kesg0, inst_kesg1;
    logic data_kesg0, data_kesg1;

    assign inst_kesg0 = instr_v_addr[31:29] == 3'b100;
    assign inst_kesg1 = instr_v_addr[31:29] == 3'b101;
    assign data_kesg0 = data_v_addr[31:29] == 3'b100;
    assign data_kesg1 = data_v_addr[31:29] == 3'b101;
    
    assign instr_p_addr = inst_kesg0 | inst_kesg1 ?
           {3'b0, instr_v_addr[28:0]} : instr_v_addr;
    
    assign data_p_addr  = data_kesg0 | data_kesg1 ?
           {3'b0, data_v_addr[28:0]}  : data_v_addr ;

    assign no_dcache = data_kesg1 ? 1'b1 : 1'b0;
    
endmodule
