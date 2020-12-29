`timescale 1ns/1ps
`include "defines.vh"

interface ader(
    logic         adel,
    logic         ades,
    logic `W_DATA addr);
    
    modport master(
        input adel,
        input ades,
        input addr);
    
    modport slave(
        output adel,
        output ades,
        output addr);
    
endinterface

