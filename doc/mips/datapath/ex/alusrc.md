| 信号名称        |  线号  | 方向 |  位宽  | 描述                       |
| --------------- | :----: | :--: | :----: | -------------------------- |
| type            | ID.I.2 | 输入 | W_TYPE | 指令类型                   |
| imme            | ID.D.1 | 输入 | W_DATA | 扩展之后的立即数           |
| forward_rs      | EX.D.1 | 输入 |   1    | 第一个源寄存器前推的有效性 |
| forward_rs_data | EX.D.1 | 输入 | W_DATA | 第一个源寄存器前推的值     |
| forward_rd      | EX.D.1 | 输入 |   1    | 第二个源寄存器前推的有效性 |
| forward_rd_data | EX.D.1 | 输入 | W_DATA | 第二个源寄存器前推的值     |
| rs_data         | ID.D.4 | 输入 | W_DATA | 第一个源寄存器值           |
| rt_data         | ID.D.4 | 输入 | W_DATA | 第二个源寄存器值           |
| source_a        | EX.D.2 | 输出 | W_DATA | 第一个运算器操作数         |
| source_b        | EX.D.2 | 输出 | W_DATA | 第二个运算器操作数         |

