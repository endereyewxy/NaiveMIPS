| 信号名称    |  线号  | 方向 |  位宽  | 描述                             |
| ----------- | :----: | :--: | :----: | -------------------------------- |
| oper        | ID.I.2 | 输入 | W_OPER | 操作码                           |
| func        | ID.I.2 | 输入 | W_FUNC | 运算码                           |
| cp0_rt_data | EX.D.4 | 输入 | W_DATA | 要读取的CP0寄存器值              |
| cp0_rd_data | EX.D.3 | 输出 | W_DATA | 要写入的CP0寄存器值              |
| source_a    | EX.D.2 | 输入 | W_DATA | 第一个操作数                     |
| source_b    | EX.D.2 | 输入 | W_DATA | 第二个操作数                     |
| result      | EX.D.5 | 输出 | W_DATA | 运算结果                         |
| mulalu_sign |        | 输出 |   1    | 输出到多周期的，是否为有符号运算 |
| mulalu_func |        | 输出 | W_FUNC | 输出到多周期的运算码             |
| hi          |        | 输入 | W_DATA | HI寄存器当前值                   |
| hi_write    |        | 输出 |   1    | 写HI寄存器使能                   |
| lo          |        | 输入 | W_DATA | LO寄存器当前值                   |
| lo_write    |        | 输出 |   1    | 写LO寄存器使能                   |
| ov          | EX.E.1 | 输出 |   1    | 运算器溢出异常                   |
