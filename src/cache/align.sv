`timescale 1ns/1ps

import includes::*;

module align(
    input  logic         clk    ,
    input  logic         rst    ,
    
    input  logic         stall  ,

    input  logic [1:0]   addr   ,
    input  logic [1:0]   size   ,
    
    input  logic `W_DATA data_wi,
    input  logic `W_DATA data_ri,
    
    output logic [3:0]   mask_wo,
    output logic `W_DATA data_wo,
    output logic `W_DATA data_ro);
    
    logic [1:0] addr_ri;
    logic [1:0] size_ri;
    
    always @(posedge clk)
        if (rst) {addr_ri, size_ri} <= 0; else if (~stall) {addr_ri, size_ri} <= {addr, size};
    
    always_comb begin
        case (size)
            2'b00:
                case (addr)
                    2'b00:
                        begin
                            mask_wo = 4'b0001;
                            data_wo = {24'h0, data_wi[ 7: 0]       };
                        end
                    2'b01:
                        begin
                            mask_wo = 4'b0010;
                            data_wo = {16'h0, data_wi[ 7: 0],  8'h0};
                        end
                    2'b10:
                        begin
                            mask_wo = 4'b0100;
                            data_wo = { 8'h0, data_wi[ 7: 0], 16'h0};
                        end
                    default: // 2'b11:
                        begin
                            mask_wo = 4'b1000;
                            data_wo = {       data_wi[ 7: 0], 24'h0};
                        end
                endcase
            2'b01:
                case (addr)
                    2'b00:
                        begin
                            mask_wo = 4'b0011;
                            data_wo = {16'h0, data_wi[15: 0]       };
                        end
                    default: // 2'b10:
                        begin
                            mask_wo = 4'b1100;
                            data_wo = {       data_wi[15: 0], 16'h0};
                        end
                endcase
            default: // 2'b10:
                begin
                    mask_wo = 4'b1111;
                    data_wo = data_wi;
                end
        endcase
    end
    
    always_comb begin
        case (size_ri)
            2'b00:
                case (addr_ri)
                    2'b00:
                        data_ro = {24'h0, data_ri[ 7: 0]       };
                    2'b01:
                        data_ro = {24'h0, data_ri[15: 8]       };
                    2'b10:
                        data_ro = {24'h0, data_ri[23:16]       };
                    default: // 2'b11:
                        data_ro = {24'h0, data_ri[31:24]       };
                endcase
            2'b01:
                case (addr_ri)
                    2'b00:
                        data_ro = {16'h0, data_ri[15: 0]       };
                    default: // 2'b10:
                        data_ro = {16'h0, data_ri[31:16]       };
                endcase
            default: // 2'b10:
                data_ro = data_ri;
        endcase
    end
    
endmodule

