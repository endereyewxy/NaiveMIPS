`define W_ADDR [31:0]
`define W_DATA [31:0]
`define W_REGF [4 :0]
`define W_TYPE [1 :0]
`define W_OPER [4 :0]
`define W_FUNC [3 :0]
`define W_EXCC [4 :0]
`define W_INTV [7 :0]

`define TYPE_R 2'b00
`define TYPE_I 2'b01
`define TYPE_J 2'b11

`define OPER_ALUS    5'b00000 // 有符号逻辑运算指令、移位指令、算数运算指令
`define OPER_ALUU    5'b00001 // 无符号逻辑运算指令、移位指令、算数运算指令
`define OPER_MFHI    5'b00100
`define OPER_MFLO    5'b00101
`define OPER_MTHI    5'b00110
`define OPER_MTLO    5'b00111
`define OPER_J       5'b01000 // j, jal
`define OPER_JR      5'b01001 // jr, jalr
`define OPER_BEQ     5'b01010
`define OPER_BNE     5'b01011
`define OPER_BGEZ    5'b01100 // bgez, bgezal
`define OPER_BGTZ    5'b01101
`define OPER_BLEZ    5'b01110
`define OPER_BLTZ    5'b01111 // bltz, bltzal
`define OPER_LB      5'b10000
`define OPER_LBU     5'b10001
`define OPER_LH      5'b10010
`define OPER_LHU     5'b10011
`define OPER_LW      5'b10100
`define OPER_SB      5'b10101
`define OPER_SH      5'b10110
`define OPER_SW      5'b10111
`define OPER_BREAK   5'b11000
`define OPER_SYSCALL 5'b11001
`define OPER_ERET    5'b11010
`define OPER_MFC0    5'b11100
`define OPER_MTC0    5'b11101

`define IS_OPER_AL(oper) ((oper & 5'b11110) == 5'b00000) // 是否为运算器指令，包括逻辑运算指令、移位指令、算数运算指令
`define IS_OPER_HL(oper) ((oper & 5'b11100) == 5'b00100) // 是否为数据移动指令
`define IS_OPER_JB(oper) ((oper & 5'b11000) == 5'b01000) // 是否为分支跳转指令
`define IS_OPER_MM(oper) ((oper & 5'b11000) == 5'b10000) // 是否为访存指令
`define IS_OPER_ER(oper) ((oper & 5'b11100) == 5'b11000) // 是否为内陷指令（包括eret）
`define IS_OPER_C0(oper) ((oper & 5'b11100) == 5'b11100) // 是否为特权指令（不包括eret）

`define FUNC_AND 4'b0000
`define FUNC_OR  4'b0001
`define FUNC_XOR 4'b0010
`define FUNC_NOR 4'b0011
`define FUNC_LUI 4'b0100
`define FUNC_SLL 4'b0101
`define FUNC_SRL 4'b0110
`define FUNC_SRA 4'b0111
`define FUNC_ADD 4'b1011
`define FUNC_SUB 4'b1100
`define FUNC_SLT 4'b1101
`define FUNC_MUL 4'b1110
`define FUNC_DIV 4'b1111

`define EXCC_INT  5'h0
`define EXCC_ADEL 5'h4
`define EXCC_ADES 5'h5
`define EXCC_SY   5'h8
`define EXCC_BP   5'h9
`define EXCC_RI   5'ha
`define EXCC_OV   5'hc

