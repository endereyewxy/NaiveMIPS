| 信号名称     |  线号  | 方向 |  位宽  | 描述                                      |
| ------------ | :----: | :--: | :----: | ----------------------------------------- |
| oper         | ID.I.2 | 输入 | W_OPER | 判断哪一类指令                            |
| func         | ID.I.2 | 输入 | W_FUNC | 用于判断R型指令的哪一类以及是否为内陷指令 |
| rt           | ID.I.2 | 输入 | W_REGF | 要写入的通用寄存器号                      |
| rd           | ID.I.2 | 输入 | W_REGF | 要写入的CP0寄存器号                       |
| cp0_out      | EX.D.4 | 输入 | W_DATA | 要写入通用寄存器的CP0寄存器数据           |
| source_a     | EX.D.2 | 输入 | W_DATA | 第一个操作数                              |
| source_b     | EX.D.2 | 输入 | W_DATA | 第二个操作数                              |
| func_mul     |        | 输出 | W_FUNC | funct段输出到多周期                       |
| source_mul_a |        | 输出 | W_DATA | 第一个操作数输出到多周期                  |
| source_mul_b |        | 输出 | W_DATA | 第二个操作数输出到多周期                  |
| cp0_in       | EX.D.3 | 输出 | W_DATA | 要写入CP0寄存器的通用寄存器的数据         |
| result       | EX.D.5 | 输出 | W_DATA | 运算结果                                  |
| sy           | EX.E.1 | 输出 |   1    | 内陷指令异常：SYSCALL                     |
| bp           | EX.E.1 | 输出 |   1    | 内陷指令异常：BREAK                       |
| ov           | EX.E.1 | 输出 |   1    | 运算器溢出异常                            |

