`timescale 1ns/1ps
`include "defines.vh"

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

