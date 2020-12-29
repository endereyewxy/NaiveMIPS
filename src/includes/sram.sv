`timescale 1ns/1ps
`include "defines.vh"

interface sram(
    logic         en    ,
    logic [3:0]   we    ,
    logic `W_ADDR addr  ,
    logic `W_DATA data_w,
    logic `W_DATA data_r);
    
    modport master(
        output en    ,
        output we    ,
        output addr  ,
        output data_w,
        input  data_r);
    
    modport slave(
        input  en    ,
        input  we    ,
        input  addr  ,
        input  data_w,
        output data_r);
    
endinterface

