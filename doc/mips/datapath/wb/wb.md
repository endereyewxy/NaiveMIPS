| 信号名称  |  线号  | 方向 |  位宽  | 描述                                 |
| --------- | :----: | :--: | :----: | ------------------------------------ |
| oper      | ID.I.2 | 输入 | W_OPER | 操作码                               |
| rd_regf   | ID.I.2 | 输入 | W_REGF | 写回寄存器号                         |
| rd_data_a | MM.D.1 | 输入 | W_DATA | 写回寄存器值来源一（运算器计算结果） |
| rd_data_b | WB.D.1 | 输入 | W_DATA | 写回寄存器值来源二（访存结果）       |
| rd_data   | WB.D.2 | 输出 | W_DATA | 写回寄存器值                         |
