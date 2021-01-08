`timescale 1ns/1ps

import includes::*;

module decode(
    input  logic `W_DATA inst   ,
    output logic `W_TYPE ityp   ,
    output logic `W_OPER oper   ,
    output logic `W_FUNC func   ,
    output logic `W_DATA imme   ,
    output logic `W_REGF rs_regf,
    output logic `W_REGF rt_regf,
    output logic `W_REGF rd_regf,
    output logic         sy     ,
    output logic         bp     ,
    output logic         ri     ,
    output logic         er     );
    
    logic [5:0] f_oper;
    logic [5:0] f_func;
    
    assign f_oper = inst[31:26];
    assign f_func = inst[5 :0 ];
    
    logic `W_REGF rd_reg_;
    
    // 注意含义：rt表示第二个源寄存器，手册中I型指令的rt实际上是目标寄存器（rd）
    assign rd_reg_ =  `IS_OPER_JB(oper)     ? 0               :
                     (oper   == `OPER_SB  |
                      oper   == `OPER_SH  |
                      oper   == `OPER_SW  ) ? 0               :
                     (func   == `FUNC_SLL |
                      func   == `FUNC_SRL |
                      func   == `FUNC_SRA ) ?     inst[15:11] :
                     (ityp   == `TYPE_I   |
                      oper   == `OPER_MFC0) ?     inst[20:16] :
                     (ityp   == `TYPE_J   ) ? 0 : inst[15:11];
    
    logic jar, jal, bal;
    
    assign jar = f_oper == 6'b000000 & f_func == 6'b001001;
    assign jal = f_oper == 6'b000011;
    assign bal = f_oper == 6'b000001 & inst[20];
    
    assign rd_regf = jar ? (inst[15:11] == 5'h0 ? 5'd31 : inst[15:11]) : (jal | bal) ? 5'd31 : rd_reg_;
    
    always @(*) begin
        ityp    = (inst[31] | inst[29] | inst[28]) ? `TYPE_I : `TYPE_R;
        oper    = 0;
        func    = 0;
        rs_regf = inst[25:21];
        rt_regf = (ityp == `TYPE_I | ityp == `TYPE_J) ? 0 : inst[20:16];
        ri      = 1'b0;
        
        case (f_oper)
            6'b000000:
                begin
                    case (f_func)
                        6'b010000: oper = `OPER_MFHI   ; // mfhi
                        6'b010010: oper = `OPER_MFLO   ; // mflo
                        6'b010001: oper = `OPER_MTHI   ; // mthi
                        6'b010011: oper = `OPER_MTLO   ; // mtlo
                        6'b001000: oper = `OPER_JR     ; // jr
                        6'b001001: oper = `OPER_JR     ; // jral
                        
                        6'b001101: begin ityp = `TYPE_J; oper = `OPER_BREAK  ; rs_regf = 5'h0; end // break
                        6'b001100: begin ityp = `TYPE_J; oper = `OPER_SYSCALL; rs_regf = 5'h0; end // syscall
                        
                        default  : oper = f_func[0] ? `OPER_ALUU : `OPER_ALUS;
                    endcase
                    
                    case (f_func)
                        6'b100100: func = `FUNC_AND ; // and
                        6'b100101: func = `FUNC_OR  ; // or
                        6'b100110: func = `FUNC_XOR ; // xor
                        6'b100111: func = `FUNC_NOR ; // nor
                        6'b000100: func = `FUNC_SLL ; // sllv
                        6'b000110: func = `FUNC_SRL ; // srlv
                        6'b000111: func = `FUNC_SRA ; // srav
                        6'b100000: func = `FUNC_ADD ; // add
                        6'b100010: func = `FUNC_SUB ; // sub
                        6'b101010: func = `FUNC_SLT ; // slt
                        6'b011000: func = `FUNC_MUL ; // mult
                        6'b011010: func = `FUNC_DIV ; // div
                        6'b100001: func = `FUNC_ADD ; // addu
                        6'b100011: func = `FUNC_SUB ; // subu
                        6'b101011: func = `FUNC_SLT ; // sltu
                        6'b011001: func = `FUNC_MUL ; // multu
                        6'b011011: func = `FUNC_DIV ; // divu
                        
                        6'b000000: begin ityp = `TYPE_I; func = `FUNC_SLL; rt_regf = inst[20:16]; end // sll
                        6'b000010: begin ityp = `TYPE_I; func = `FUNC_SRL; rt_regf = inst[20:16]; end // srl
                        6'b000011: begin ityp = `TYPE_I; func = `FUNC_SRA; rt_regf = inst[20:16]; end // sra
                    endcase
                end
            
            6'b000001: // bltz(al), bgez(al)
                begin
                    ityp = `TYPE_I;
                    oper = inst[16] ? `OPER_BGEZ : `OPER_BLTZ;
                end
            
            6'b010000:
                begin
                    case (inst[25:23])
                        3'b001: begin oper = `OPER_MTC0; rs_regf = 5'h0;                        end // mtc0
                        3'b000: begin oper = `OPER_MFC0; rs_regf = 5'h0; rt_regf = inst[15:11]; end // mfc0
                        
                        3'b100: begin ityp = `TYPE_J; oper = `OPER_ERET; rs_regf = 5'h0; end // eret
                        
                        default: ri = 1'b1;
                    endcase
                end
            
            6'b001100: begin oper = `OPER_ALUU; func = `FUNC_AND; end // andi
            6'b001110: begin oper = `OPER_ALUU; func = `FUNC_XOR; end // xori
            6'b001111: begin oper = `OPER_ALUU; func = `FUNC_LUI; end // lui
            6'b001101: begin oper = `OPER_ALUU; func = `FUNC_OR ; end // ori
            6'b001000: begin oper = `OPER_ALUS; func = `FUNC_ADD; end // addi
            6'b001001: begin oper = `OPER_ALUU; func = `FUNC_ADD; end // addiu
            6'b001010: begin oper = `OPER_ALUS; func = `FUNC_SLT; end // slti
            6'b001011: begin oper = `OPER_ALUU; func = `FUNC_SLT; end // sltiu
            
            6'b000010: begin ityp = `TYPE_J; oper = `OPER_J; rs_regf = 5'h0; end // j
            6'b000011: begin ityp = `TYPE_J; oper = `OPER_J; rs_regf = 5'h0; end // jal
            
            6'b000100: begin oper = `OPER_BEQ; rt_regf = inst[20:16]; end // beq
            6'b000101: begin oper = `OPER_BNE; rt_regf = inst[20:16]; end // bne
            
            6'b000111: oper = `OPER_BGTZ; // bgtz
            6'b000110: oper = `OPER_BLEZ; // blez
            
            6'b100000: begin oper = `OPER_LB ; func = `FUNC_ADD; end // lb
            6'b100100: begin oper = `OPER_LBU; func = `FUNC_ADD; end // lbu
            6'b100001: begin oper = `OPER_LH ; func = `FUNC_ADD; end // lh
            6'b100101: begin oper = `OPER_LHU; func = `FUNC_ADD; end // lhu
            6'b100011: begin oper = `OPER_LW ; func = `FUNC_ADD; end // lw
            
            6'b101000: begin oper = `OPER_SB ; func = `FUNC_ADD; rt_regf = inst[20:16]; end // sb
            6'b101001: begin oper = `OPER_SH ; func = `FUNC_ADD; rt_regf = inst[20:16]; end // sh
            6'b101011: begin oper = `OPER_SW ; func = `FUNC_ADD; rt_regf = inst[20:16]; end // sw
            
            6'b111111: begin oper = `OPER_ALUS; func = `FUNC_ABS; ityp = `TYPE_R; rt_regf = 0; rd_regf = inst[15:11]; end
            
            default: ri = 1'b1;
        endcase
    end
    
    assign imme =
        (ityp == `TYPE_I) ? (
            (func == `FUNC_SLL |
             func == `FUNC_SRL |
             func == `FUNC_SRA )     ? {27'h0         , inst[10:6]} :    // 特殊处理
            (f_oper[5:2] == 4'b0011) ? {16'h0         , inst[15:0]} :    // 无符号扩展
                                       {{16{inst[15]}}, inst[15:0]}):    // 有符号扩展
        (ityp == `TYPE_J)            ? {6'h0          , inst[25:0]} : 0; // 皆可
    
    assign sy = oper == `OPER_SYSCALL;
    assign bp = oper == `OPER_BREAK;
    assign er = oper == `OPER_ERET;
    
endmodule


