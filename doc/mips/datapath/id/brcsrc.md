| 信号            | 线号   | 方向 | 位宽   | 描述                       |
| --------------- | ------ | ---- | ------ | -------------------------- |
| forward_rs      | ID.D.3 | 输入 | 1      | 第一个源寄存器前推的有效性 |
| forward_rs_data | ID.D.3 | 输入 | W_DATA | 第一个源寄存器前推的值     |
| forward_rd      | ID.D.3 | 输入 | 1      | 第二个源寄存器前推的有效性 |
| forward_rd_data | ID.D.3 | 输入 | W_DATA | 第二个源寄存器前推的值     |
| rs_data         | ID.D.4 | 输入 | W_DATA | 第一个源寄存器值           |
| rt_data         | ID.D.4 | 输入 | W_DATA | 第二个源寄存器值           |
| source_a        | ID.D.2 | 输出 | W_DATA | 第一个分支模块操作数       |
| source_b        | ID.D.2 | 输出 | W_DATA | 第二个分支模块操作数       |

