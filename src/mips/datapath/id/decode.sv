`timescale 1ns/1ps
`include "defines.vh"

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
    
    logic n_ri;
    
    assign {n_ri, oper, func} =
        (f_oper == 6'b000000) ? (
            (f_func == 6'b100100) ? {1'b1, `OPER_ALUS, `FUNC_AND } : // and
            (f_func == 6'b100101) ? {1'b1, `OPER_ALUS, `FUNC_OR  } : // or
            (f_func == 6'b100110) ? {1'b1, `OPER_ALUS, `FUNC_XOR } : // xor
            (f_func == 6'b100111) ? {1'b1, `OPER_ALUS, `FUNC_NOR } : // nor
            
            (f_func == 6'b000000) ? {1'b1, `OPER_ALUS, `FUNC_SLL } : // sll
            (f_func == 6'b000010) ? {1'b1, `OPER_ALUS, `FUNC_SRL } : // srl
            (f_func == 6'b000011) ? {1'b1, `OPER_ALUS, `FUNC_SRA } : // sra
            (f_func == 6'b000100) ? {1'b1, `OPER_ALUS, `FUNC_SLL } : // sllv
            (f_func == 6'b000110) ? {1'b1, `OPER_ALUS, `FUNC_SRL } : // srlv
            (f_func == 6'b000111) ? {1'b1, `OPER_ALUS, `FUNC_SRA } : // srav
            
            (f_func == 6'b010000) ? {1'b1, `OPER_MFHI, `FUNC_AND } : // mfhi
            (f_func == 6'b010010) ? {1'b1, `OPER_MFLO, `FUNC_AND } : // mflo
            (f_func == 6'b010001) ? {1'b1, `OPER_MTHI, `FUNC_AND } : // mthi
            (f_func == 6'b010011) ? {1'b1, `OPER_MTLO, `FUNC_AND } : // mtlo
            
            (f_func == 6'b100000) ? {1'b1, `OPER_ALUS, `FUNC_ADD } : // add
            (f_func == 6'b100010) ? {1'b1, `OPER_ALUS, `FUNC_SUB } : // sub
            (f_func == 6'b101010) ? {1'b1, `OPER_ALUS, `FUNC_SLT } : // slt
            (f_func == 6'b011000) ? {1'b1, `OPER_ALUS, `FUNC_MUL } : // mult
            (f_func == 6'b011010) ? {1'b1, `OPER_ALUS, `FUNC_DIV } : // div
            
            (f_func == 6'b100001) ? {1'b1, `OPER_ALUU, `FUNC_ADD } : // addu
            (f_func == 6'b100011) ? {1'b1, `OPER_ALUU, `FUNC_SUB } : // subu
            (f_func == 6'b101011) ? {1'b1, `OPER_ALUU, `FUNC_SLT } : // sltu
            (f_func == 6'b011001) ? {1'b1, `OPER_ALUU, `FUNC_MUL } : // multu
            (f_func == 6'b011011) ? {1'b1, `OPER_ALUU, `FUNC_DIV } : // divu
            
            (f_func == 6'b001000) ? {1'b1, `OPER_JR  , `FUNC_AND } : // jr
            (f_func == 6'b001001) ? {1'b1, `OPER_JR  , `FUNC_AND } : // jral
            
            (f_func == 6'b001101) ? {1'b1, `OPER_BREAK  , `FUNC_AND } : // break
            (f_func == 6'b001100) ? {1'b1, `OPER_SYSCALL, `FUNC_AND } : // syscall
            0) :
        
        (f_oper == 6'b001100) ? {1'b1, `OPER_ALUU, `FUNC_AND } : // andi
        (f_oper == 6'b001110) ? {1'b1, `OPER_ALUU, `FUNC_XOR } : // xori
        (f_oper == 6'b001111) ? {1'b1, `OPER_ALUU, `FUNC_LUI } : // lui
        (f_oper == 6'b001101) ? {1'b1, `OPER_ALUU, `FUNC_OR  } : // ori
        
        (f_oper == 6'b001000) ? {1'b1, `OPER_ALUS, `FUNC_ADD } : // addi
        (f_oper == 6'b001001) ? {1'b1, `OPER_ALUU, `FUNC_ADD } : // addiu
        (f_oper == 6'b001010) ? {1'b1, `OPER_ALUS, `FUNC_SLT } : // slti
        (f_oper == 6'b001011) ? {1'b1, `OPER_ALUU, `FUNC_SLT } : // sltiu
        
        (f_oper == 6'b000010) ? {1'b1, `OPER_J   , `FUNC_AND } : // j
        (f_oper == 6'b000011) ? {1'b1, `OPER_J   , `FUNC_AND } : // jal
        (f_oper == 6'b000100) ? {1'b1, `OPER_BEQ , `FUNC_AND } : // beq
        (f_oper == 6'b000111) ? {1'b1, `OPER_BGTZ, `FUNC_AND } : // bgtz
        (f_oper == 6'b000110) ? {1'b1, `OPER_BLEZ, `FUNC_AND } : // blez
        (f_oper == 6'b000101) ? {1'b1, `OPER_BNE , `FUNC_AND } : // bne
        (f_oper == 6'b000001) ? (
            (inst[20:16] == 5'b00000) ? {1'b1, `OPER_BLTZ, `FUNC_AND } : // bltz 
            (inst[20:16] == 5'b10000) ? {1'b1, `OPER_BLTZ, `FUNC_AND } : // bltzal
            (inst[20:16] == 5'b00001) ? {1'b1, `OPER_BGEZ, `FUNC_AND } : // bgez
            (inst[20:16] == 5'b10001) ? {1'b1, `OPER_BGEZ, `FUNC_AND } : // bgezal
            0) :
        
        (f_oper == 6'b100000) ? {1'b1, `OPER_LB  , `FUNC_ADD } : // lb
        (f_oper == 6'b100100) ? {1'b1, `OPER_LBU , `FUNC_ADD } : // lbu
        (f_oper == 6'b100001) ? {1'b1, `OPER_LH  , `FUNC_ADD } : // lh
        (f_oper == 6'b100101) ? {1'b1, `OPER_LHU , `FUNC_ADD } : // lhu
        (f_oper == 6'b100011) ? {1'b1, `OPER_LW  , `FUNC_ADD } : // lw
        (f_oper == 6'b101000) ? {1'b1, `OPER_SB  , `FUNC_ADD } : // sb
        (f_oper == 6'b101001) ? {1'b1, `OPER_SH  , `FUNC_ADD } : // sh
        (f_oper == 6'b101011) ? {1'b1, `OPER_SW  , `FUNC_ADD } : // sw
        
        (f_oper == 6'b010000) ? (
            (inst[25:21] == 5'b00100) ? {1'b1, `OPER_MTC0, `FUNC_AND} : // mtc0
            (inst[25:21] == 5'b00000) ? {1'b1, `OPER_MFC0, `FUNC_AND} : // mfc0
            (inst[25:21] == 5'b10000) ? {1'b1, `OPER_ERET, `FUNC_AND} : // eret
            0) :
        0;
    
    assign ityp =
        (inst[31] | inst[29] | inst[28] | f_oper == 6'b000001) ? `TYPE_I :
        ((func == `FUNC_SLL     |
          func == `FUNC_SRL     |
          func == `FUNC_SRA     ) & ~inst[2])                  ? `TYPE_I :
        (oper == `OPER_J       |
         oper == `OPER_BREAK   |
         oper == `OPER_SYSCALL |
         oper == `OPER_ERET    )                               ? `TYPE_J : `TYPE_R;
    
    assign imme =
        (ityp == `TYPE_I) ? (
            (func == `FUNC_SLL |
             func == `FUNC_SRL |
             func == `FUNC_SRA )     ? {27'h0         , inst[10:6]} :    // 特殊处理
            (f_oper[5:2] == 4'b0011) ? {16'h0         , inst[15:0]} :    // 无符号扩展
                                       {{16{inst[15]}}, inst[15:0]}):    // 有符号扩展
        (ityp == `TYPE_J)            ? {6'h0          , inst[25:0]} : 0; // 皆可
    
    logic `W_REGF rd_reg_;
    
    // MTC0和MFC0需要特殊处理：它们的没有第一个源寄存器
    assign rs_regf = (ityp   == `TYPE_J    |
                      oper   == `OPER_MTC0 |
                      oper   == `OPER_MFC0 ) ? 0 : inst[25:21];
    // 注意含义：rt表示第二个源寄存器，手册中I型指令的rt实际上是目标寄存器（rd）
    assign rt_regf = (oper   == `OPER_BEQ  |
                      oper   == `OPER_BNE  ) ?     inst[20:16] :
                     (ityp   == `TYPE_J    |
                      ityp   == `TYPE_I    ) ? 0 : inst[20:16];
    assign rd_reg_ = (`IS_OPER_JB(oper)    |
                      `IS_OPER_MM(oper)    ) ? 0               :
                     (ityp   == `TYPE_I    ) ?     inst[20:16] :
                     (ityp   == `TYPE_J    ) ? 0 : inst[15:11];
    
    logic jar, jal, bal;
    
    assign jar = f_oper == 6'b000000 & f_func == 6'b001001;
    assign jal = f_oper == 6'b000011;
    assign bal = f_oper == 6'b000001 & inst[20];
    
    assign rd_regf = jar ? (inst[15:11] == 5'h0 ? 5'd31 : 0) : (jal | bal) ? 5'd31 : rd_reg_;
    
    assign sy = oper == `OPER_SYSCALL;
    assign bp = oper == `OPER_BREAK;
    assign ri = ~n_ri;
    assign er = oper == `OPER_ERET;
    
endmodule

