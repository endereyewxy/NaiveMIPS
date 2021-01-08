`timescale 1ns/1ps

import includes::*;

module sglalu(
    input  logic `W_OPER oper         ,
    input  logic `W_FUNC func         ,
    input  logic `W_DATA cp0_rt_data  ,
    output logic         cp0_rd_we    ,
    output logic `W_DATA cp0_rd_data  ,
    input  logic `W_DATA source_a     ,
    input  logic `W_DATA source_b     ,
    output logic `W_DATA result       ,
    output logic         mulalu_sign  ,
    output logic `W_FUNC mulalu_func  ,
    input  logic `W_DATA hi           ,
    output logic         hi_write     ,
    input  logic `W_DATA lo           ,
    output logic         lo_write     ,
    output logic         ov           );
    
    assign cp0_rd_we   = oper == `OPER_MTC0;
    assign cp0_rd_data = source_b;
    
    assign mulalu_func = (func == `FUNC_MUL | func == `FUNC_DIV) ? func : 5'b00000;
    assign mulalu_sign = oper == `OPER_ALUS;
    
    assign hi_write = oper == `OPER_MTHI;
    assign lo_write = oper == `OPER_MTLO;
    
    logic `W_DATA add_result;
    logic `W_DATA and_result;
    logic `W_DATA sub_result;
    logic `W_DATA  or_result;
    logic `W_DATA xor_result;
    logic `W_DATA slt_result;

    assign add_result = source_a + source_b;
    assign and_result = source_a & source_b;
    assign sub_result = source_a - source_b;
    assign  or_result = source_a | source_b;
    assign xor_result = source_a ^ source_b;
    assign slt_result = {32'h0, xor_result[31] ? source_a[31] : source_a < source_b};
    
    always @(*) begin
        case (oper)
            `OPER_MFHI: result = hi;
            `OPER_MFLO: result = lo;
            `OPER_MFC0: result = cp0_rt_data;
            
            default:
                case (func)
                    `FUNC_OR : result =  or_result                ;
                    `FUNC_XOR: result = xor_result                ;
                    `FUNC_NOR: result = ~or_result                ;
                    `FUNC_LUI: result = {source_b[15:0], 16'h0}   ;
                    `FUNC_SLL: result =  source_a << source_b[4:0];
                    `FUNC_SRL: result =  source_a >> source_b[4:0];
                    `FUNC_ADD: result = add_result                ;
                    `FUNC_AND: result = and_result                ;
                    `FUNC_SUB: result = sub_result                ;
                    
                    `FUNC_SRA: result = ({32{source_a[31]}} << (32'd32 - source_b[4:0])) | (source_a >> source_b[4:0]); // FIXME
                    
                    `FUNC_SLT: result = mulalu_sign ? slt_result : {31'h0, source_a < source_b};
                    
                    `FUNC_ABS: result = source_a[31] ? (0 - source_a) : source_a;
                    
                    default: result = 32'h0;
                endcase
        endcase
    end
    
    assign ov = mulalu_sign & ((func == `FUNC_ADD & ~xor_result[31]) | (func == `FUNC_SUB & xor_result[31])) & (source_a[31] ^ result[31]);
    
endmodule

