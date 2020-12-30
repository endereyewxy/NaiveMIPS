`timescale 1ns/1ps
`include "defines.vh"

module memctl(
    input  logic `W_OPER oper       ,
    input  logic `W_ADDR source_addr,
    input  logic `W_DATA source_data,
    output logic         dbus_en    ,
    output logic [3:0]   dbus_we    ,
    output logic `W_ADDR dbus_addr  ,
    output logic `W_DATA dbus_data  ,
    output logic [1:0]   word_offset);

    assign dbus_en = `IS_OPER_MM(oper);
    
    logic [3:0] unoffset_we;
    
    assign unoffset_we = oper == `OPER_SB ? 4'b0001 :
                         oper == `OPER_SH ? 4'b0011 :
                         oper == `OPER_SW ? 4'b1111 : 4'b0000;
    
    logic `W_DATA offset_data;
    
    assign {dbus_we, offset_data} =
        (source_addr[1:0] == 2'b00) ? {unoffset_we           , source_data             } :
        (source_addr[1:0] == 2'b01) ? {unoffset_we[2:0], 1'h0, source_data[23:0],  8'h0} :
        (source_addr[1:0] == 2'b10) ? {unoffset_we[1:0], 2'h0, source_data[15:0], 16'h0} :
                                      {unoffset_we[0  ], 3'h0, source_data[ 7:0], 24'h0} ;
    
    assign dbus_addr = {source_addr[31:2], 2'b00};

    assign dbus_data = (oper == `OPER_SB | oper == `OPER_SH | oper == `OPER_SW) ? offset_data : source_addr;
    
    assign word_offset = source_addr[1:0];
    
endmodule

