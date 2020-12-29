`timescale 1ns/1ps
`include "defines.vh"

interface ader(
    logic         adel,
    logic         ades,
    logic `W_DATA addr);
    
    modport master(
        output adel,
        output ades,
        output addr);
    
    modport slave(
        input adel,
        input ades,
        input addr);
    
endinterface

