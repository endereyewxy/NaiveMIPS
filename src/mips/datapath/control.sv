`timescale 1ns/1ps

module control(
    input  logic ibus       ,
    input  logic dbus       ,
    input  logic forward    ,
    input  logic mulalu     ,
    input  logic except     ,
    output logic if_id_stall,
    output logic if_id_flush,
    output logic id_ex_stall,
    output logic id_ex_flush,
    output logic ex_mm_stall,
    output logic ex_mm_flush,
    output logic mm_wb_stall,
    output logic mm_wb_flush,
    output logic pc_stall   ,
    output logic pc_flush   ,
    output logic ibus_pause ,
    output logic dbus_pause );
    
    logic id_ex;
    logic ex_mm;
    logic mm_wb;
    
    assign {id_ex, ex_mm, mm_wb} = dbus ? 3'b001 :
                                         mulalu  ? 3'b010 :
                     (ibus | forward)  ? 3'b100 : 3'b000;
    
    assign if_id_stall = mm_wb | ex_mm | id_ex;
    assign id_ex_stall = mm_wb | ex_mm        ;
    assign ex_mm_stall = mm_wb                ;
    assign mm_wb_stall = mm_wb                ;
    
    assign if_id_flush = except;
    assign id_ex_flush = except | id_ex;
    assign ex_mm_flush = except | ex_mm;
    assign mm_wb_flush = except;
    
    assign pc_stall = if_id_stall;
    assign pc_flush = 1'b0;
    
    assign ibus_pause = dbus | mulalu | forward;
    assign dbus_pause = 1'b0;
    
endmodule

