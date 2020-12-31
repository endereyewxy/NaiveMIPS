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
    output logic pc_flush   );
    
    logic if_id;
    logic id_ex;
    logic ex_mm;
    logic mm_wb;
    
    assign {if_id, id_ex, ex_mm, mm_wb} =
        dbus    ? 4'b0001 :
        mulalu  ? 4'b0010 :
        forward ? 4'b0100 :
        ibus    ? 4'b1000 : 4'b0000;
    
    assign if_id_stall = mm_wb | ex_mm | id_ex | if_id;
    assign id_ex_stall = mm_wb | ex_mm | id_ex        ;
    assign ex_mm_stall = mm_wb | ex_mm                ;
    assign mm_wb_stall = mm_wb                        ;
    
    assign if_id_flush = if_id         ;
    assign id_ex_flush = id_ex | except;
    assign ex_mm_flush = ex_mm | except;
    assign mm_wb_flush = mm_wb | except;
    
    assign pc_stall = if_id_stall;
    assign pc_flush = 1'b0;
    
endmodule

