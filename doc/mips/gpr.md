| 信号    |  线号  | 方向 |  位宽  | 描述                   |
| ------- | :----: | :--: | :----: | ---------------------- |
| rs_regf | ID.I.2 | 输入 | W_REGF | 第一个源寄存器号       |
| rs_data | ID.D.4 | 输出 | W_DATA | 第一个源寄存器值       |
| rt_regf | ID.I.2 | 输入 | W_REGF | 第二个源寄存器号       |
| rt_data | ID.D.4 | 输出 | W_DATA | 第二个源寄存器值       |
| rd_regf | WB.D.2 | 输入 | W_REGF | 目标寄存器号，无则为零 |
| rd_data | WB.D.2 | 输入 | W_DATA | 目标寄存器值           |

