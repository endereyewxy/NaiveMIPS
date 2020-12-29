`timescale 1ns/1ps
`include "defines.vh"

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

