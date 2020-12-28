| 信号         | 线号   | 方向 | 位宽   | 描述                  |
| ------------ | ------ | ---- | ------ | --------------------- |
| rs_regf      | ID.I.2 | 输入 | W_REGF | 第一个源寄存器号      |
| rt_regf      | ID.I.2 | 输入 | W_REGF | 第二个源寄存器号      |
| into_id_regf | ID.D.3 | 输入 | W_REGF | 前推寄存器号，没有为0 |
| into_id_data | ID.D.3 | 输入 | W_DATA | 前推的数据            |
| src_a        | ID.D.4 | 输入 | W_DATA | 第一个运算器操作数    |
| src_b        | ID.D.4 | 输入 | W_DATA | 第二个运算器操作数    |
| rs           | ID.D.2 | 输出 | W_DATA | 第一个源寄存器数据    |
| rt           | ID.D.2 | 输出 | W_DATA | 第二个源寄存器数据    |

