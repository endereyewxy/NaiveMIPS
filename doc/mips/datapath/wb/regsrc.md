| 信号名称   |  线号  | 方向 |  位宽  | 描述               |
| ---------- | :----: | :--: | :----: | ------------------ |
| oper       | ID.I.2 | 输入 | W_OPER | 指令操作码         |
| write_regf | ID.I.2 | 输入 | W_REGF | 写寄存器号         |
| alu_res    | MM.D.1 | 输入 | W_DATA | alu运算的结果      |
| mem_data   | WB.D.1 | 输入 | W_DATA | 从内存中读出的数据 |
| data       | WB.D.2 | 输出 | W_DATA | 要写回的数据       |
