`timescale 1ns/1ps

import includes::*;

module toslk(
    input      logic         clk       ,
    input      logic         rst       ,
    
    input      logic         cpu_en    ,
    input      logic         cpu_we    ,
    input      logic [1:0]   cpu_size  ,
    input      logic `W_ADDR cpu_addr  ,
    input      logic `W_DATA cpu_data_w,
    output     logic `W_DATA cpu_data_r,
    input      logic         cpu_pause ,
    output     logic         cpu_stall ,
    
    output     logic         mem_en    ,
    output     logic         mem_we    ,
    output     logic [1:0]   mem_size  ,
    output     logic `W_ADDR mem_addr  ,
    output     logic `W_DATA mem_data_w,
    input      logic `W_DATA mem_data_r,
    input      logic         mem_addr_o,
    input      logic         mem_data_o);
    
    logic state;
    
    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    
    always @(posedge clk) begin
        if (rst)
            {state, mem_en} <= {IDLE, 1'b0};
        else
            case (state)
                IDLE:
                    begin
                        if (cpu_en & ~cpu_pause) begin
                            mem_en     <= 1'b1;
                            mem_we     <= cpu_we;
                            mem_addr   <= cpu_addr;
                            mem_size   <= cpu_size;
                            mem_data_w <= cpu_data_w;
                            state      <= WORK;
                        end
                    end
                WORK:
                    begin
                        if (mem_addr_o)
                            mem_en     <= 1'b0;
                        if (mem_data_o) begin
                            state      <= IDLE;
                            cpu_data_r <= mem_data_r;
                        end
                    end
            endcase
    end
    
    assign cpu_stall = state== WORK;
    
endmodule

