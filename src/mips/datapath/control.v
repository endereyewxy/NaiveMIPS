`timescale 1ns/1ps

module control(
    input  wire ibus       ,
    input  wire dbus       ,
    input  wire forward    ,
    input  wire mulalu     ,
    input  wire except     ,
    output wire if_id_stall,
    output wire if_id_flush,
    output wire id_ex_stall,
    output wire id_ex_flush,
    output wire ex_mm_stall,
    output wire ex_mm_flush,
    output wire mm_wb_stall,
    output wire mm_wb_flush,
    output wire pc_stall   ,
    output wire pc_flush   );
    
    wire if_id;
    wire id_ex;
    wire ex_mm;
    wire mm_wb;
    
    assign {if_id, id_ex, ex_mm, mm_wb} =
        dbus    ? 4'b0001 :
        mulalu  ? 4'b0010 :
        forward ? 4'b0100 :
        ibus    ? 4'b1000 : 4'b0000;
    
    assign if_id_stall = mm_wb | ex_mm | id_ex | if_id;
    assign id_ex_stall = mm_wb | ex_mm | id_ex        ;
    assign ex_mm_stall = mm_wb | ex_mm                ;
    assign mm_wb_stall = mm_wb                        ;
    
    assign if_id_flush = if_id | except;
    assign id_ex_flush = id_ex | except;
    assign ex_mm_flush = ex_mm | except;
    assign mm_wb_flush = mm_wb | except;
    
    assign pc_stall = if_id_stall;
    assign pc_flush = 1'b0;
    
endmodule

