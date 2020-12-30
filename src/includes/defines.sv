`timescale 1ns/1ps
`include "defines.vh"

typedef struct packed {
    logic         adel;
    logic         ades;
    logic `W_ADDR addr;
} bus_error; // 总线错误

typedef struct packed {
    logic `W_INTV intr_vect;
    logic         sy       ;
    logic         bp       ;
    logic         ri       ;
    logic         ov       ;
    logic         er       ;
    logic `W_ADDR er_epc   ;
} exe_error; // 流水线中产生的（包括计算屏蔽之后的中断向量）

typedef struct packed {
    logic         we ;
    logic         bd ;
    logic         exl;
    logic `W_EXCC exc;
    logic `W_ADDR epc;
    logic `W_ADDR bva;
} reg_error; // 错误处理向CP0寄存器输出的信息

interface regf_r(
    logic `W_REGF regf,
    logic `W_DATA data);
    
    modport master(
        output regf,
        input  data);
    
    modport slave(
        input  regf,
        output data);
    
endinterface

interface regf_w(
    logic `W_REGF regf,
    logic `W_DATA data);
    
    modport master(
        output regf,
        output data);
    
    modport slave(
        input regf,
        input data);
    
endinterface

interface sram(input logic clk);
    logic         en    ;
    logic [3:0]   we    ;
    logic `W_ADDR addr  ;
    logic `W_DATA data_w;
    logic `W_DATA data_r;
    logic         stall ;
    
    clocking cb @(posedge clk);
        input en    ;
        input we    ;
        input addr  ;
        input data_w;
        input data_r;
        input stall ;
    endclocking
    
    modport master(
        output en    ,
        output we    ,
        output addr  ,
        output data_w,
        input  data_r,
        input  stall );
    
    modport slave(
        input  en    ,
        input  we    ,
        input  addr  ,
        input  data_w,
        output data_r,
        output stall );
    
endinterface

