| 信号名称      |  线号  | 方向 |  位宽  | 描述                  |
| ------------- | :----: | :--: | :----: | --------------------- |
| clk           |        | 输入 |   1    | 时钟                  |
| rst           |        | 输入 |   1    | 复位                  |
| reg_stall     |        | 输入 |   1    | ID-EX间寄存器停顿信号 |
| func          |        | 输入 | W_FUNC | 运算器操作码          |
| source_a      |        | 输入 | W_DATA | 第一个操作数          |
| source_b      |        | 输入 | W_DATA | 第二个操作数          |
| hi_write      |        | 输入 |   1    | 写HI寄存器使能        |
| hi_write_data |        | 输入 | W_DATA | 写HI寄存器数据        |
| lo_write      |        | 输入 |   1    | 写LO寄存器使能        |
| lo_write_data |        | 输入 | W_DATA | 写LO寄存器数据        |
| alu_stall     | EX.C.1 | 输出 |   1    | 停顿请求              |
| hi            |        | 输出 | W_DATA | HI寄存器当前值        |
| lo            |        | 输出 | W_DATA | LO寄存器当前值        |
| result        |        | 输出 | W_DATA | 运算结果              |


