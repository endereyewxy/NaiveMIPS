`timescale 1ns/1ps
`include "defines.vh"

module mulalu(
    input  logic         clk          ,
    input  logic         rst          ,
    
    input  logic         reg_stall    ,
    output logic         alu_stall    ,
    
    input  logic `W_OPER oper         ,
    input  logic `W_FUNC func         ,
    input  logic `W_DATA source_a     ,
    input  logic `W_DATA source_b     ,
    output logic `W_DATA result       ,
    
    output logic `W_DATA hi           ,
    input  logic         hi_write     ,
    input  logic `W_DATA hi_write_data,
    
    output logic `W_DATA lo           ,
    input  logic         lo_write     ,
    input  logic `W_DATA lo_write_data);
    
    always @(posedge clk) begin
        if (hi_write) hi <= hi_write_data;
        if (lo_write) lo <= lo_write_data;
    end
    
    
    logic is_sgn;
    logic is_mul;
    logic is_div;
    
    assign is_sgn = oper == `OPER_ALUS;
    assign is_mul = func == `FUNC_MUL;
    assign is_div = func == `FUNC_DIV;
    
    localparam NORM = 2'b00; // 就绪
    localparam WORK = 2'b01; // 工作
    localparam DONE = 2'b11; // 完成
    
    logic [1:0] state;
    
    logic [63:0] number_a;
    logic [63:0] number_b;
    
    logic       ready;
    logic [5:0] count;
    
    assign alu_stall = ~ready & (is_mul | is_div);
    
    always @(posedge clk) begin
        if (rst) begin
            state <= NORM;
            hi    <= 32'h0;
            lo    <= 32'h0;
        end else if (is_mul) begin
            
            case (state)
                NORM:
                    begin
                        state    <= WORK;
                        {hi, lo} <= 64'h0;
                        ready    <= 1'b0;
                        if (is_sgn) begin
                            number_a <= {{32{source_a[31]}}, source_a};
                            number_b <= {{32{source_b[31]}}, source_b};
                        end else begin
                            number_a <= {32'h0, source_a};
                            number_b <= {32'h0, source_b};
                        end
                    end
                WORK:
                    if (number_a == 0) begin
                        state <= DONE;
                        ready <= 1'b1;
                    end else begin
                        if (number_a[0])
                            {hi, lo} <= {hi, lo} + number_b;
                        number_a <= {1'b0, number_a[63:1]};
                        number_b <= {number_b[62:0], 1'b0};
                    end
                DONE:
                    if (~reg_stall) begin
                        state <= NORM;
                    end
                default:;
            endcase
            
        end else if (is_div) begin
            
            case (state)
                NORM:
                    begin
                        state    <= WORK;
                        {hi, lo} <= 64'h0;
                        ready    <= 1'b0;
                        count    <= 6'd32;
                        if (is_sgn & source_a[31])
                            number_a <= {32'h0, ~source_a + 1};
                        else
                            number_a <= {32'h0,  source_a};
                        if (is_sgn & source_b[31])
                            number_b <= {~source_b + 1, 32'h0};
                        else
                            number_b <= { source_b    , 32'h0};
                    end
                WORK:
                    if (count == 0) begin
                        state <= DONE;
                        ready <= 1'b1;
                        if (is_sgn & (source_a[31] ^ source_b[31]))
                            hi <= ~number_a[63:32] + 1;
                        else
                            hi <=  number_a[63:32];
                        if (is_sgn & (source_a[31] ^ source_b[63]))
                            lo <= ~number_a[31:0] + 1;
                        else
                            lo <=  number_a[31:0];
                    end else begin
                        if ({number_a[62:0], 1'b0} >= number_b)
                            number_a <= {number_a[62:0], 1'b0} - number_b + 1;
                        else
                            number_a <= {number_a[62:0], 1'b0};
                        count <= count - 1;
                    end
                DONE:
                    if (~reg_stall) begin
                        state <= NORM;
                    end
                default:;
            endcase
            
        end
    end

endmodule

