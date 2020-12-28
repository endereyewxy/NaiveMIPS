| 信号         |  线号  | 方向 |  位宽  | 描述                         |
| ------------ | :----: | :--: | :----: | ---------------------------- |
| from_ex_regf | EX.D.5 | 输入 | W_REGF | 来自EX阶段，要写回的寄存器号 |
| from_ex_data | EX.D.5 | 输入 | W_DATA | 来自EX阶段，要写回的数据     |
| from_mm_regf | MM.D.1 | 输入 | W_REGF | 来自MM阶段，要写回的寄存器号 |
| from_mm_data | MM.D.1 | 输入 | W_DATA | 来自MM阶段，要写回的数据     |
| from_wb_regf | WB.D.2 | 输入 | W_REGF | 来自WB阶段，要写回的寄存器号 |
| from_wb_data | WB.D.2 | 输入 | W_DATA | 来自WB阶段，要写回的数据     |
| into_id_regf | ID.D.3 | 输入 | W_REGF | ID阶段需要读的寄存器号       |
| into_ex_regf | EX.D.1 | 输入 | W_REGF | EX阶段需要读的寄存器号       |
| stall        |        | 输出 |   1    | 停顿请求                     |
| into_id      | ID.D.3 | 输出 |   1    | 向ID阶段，前推的数据的有效性 |
| into_id_data | ID.D.3 | 输出 | W_DATA | 向ID阶段，前推的数据         |
| into_ex      | EX.D.1 | 输出 |   1    | 向EX阶段，前推的数据的有效性 |
| into_ex_data | EX.D.1 | 输出 | W_DATA | 向EX阶段，前推的数据         |

