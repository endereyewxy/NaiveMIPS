`timescale 1ns/1ps
`include "defines.vh"

interface regf_e(
    logic         we ,
    logic         bd ,
    logic         exl,
    logic `W_EXCC exc,
    logic `W_ADDR epc,
    logic `W_ADDR bva);
    
    modport master(
        output we ,
        output bd ,
        output exl,
        output exc,
        output epc,
        output bva);
    
    modport slave(
        input we ,
        input bd ,
        input exl,
        input exc,
        input epc,
        input bva);
    
endinterface

