| 信号名称      |  线号  | 方向 |  位宽  | 描述                  |
| ------------- | :----: | :--: | :----: | --------------------- |
| clk           |        | 输入 |   1    | 时钟信号              |
| rst           |        | 输入 |   1    | 复位信号              |
| reg_flush     |        | 输入 |   1    | ID-EX间寄存器刷新信号 |
| reg_stall     |        | 输入 |   1    | ID-EX间寄存器停顿信号 |
| alu_stall     | EX.C.1 | 输出 |   1    | 停顿请求              |
| sign          |        | 输入 |   1    | 是否为有符号运算      |
| func          |        | 输入 | W_FUNC | 运算码                |
| source_a      |        | 输入 | W_DATA | 第一个操作数          |
| source_b      |        | 输入 | W_DATA | 第二个操作数          |
| hi            |        | 输出 | W_DATA | HI寄存器当前值        |
| hi_write      |        | 输入 |   1    | 写HI寄存器使能        |
| hi_write_data |        | 输入 | W_DATA | 写HI寄存器数据        |
| lo            |        | 输出 | W_DATA | LO寄存器当前值        |
| lo_write      |        | 输入 |   1    | 写LO寄存器使能        |
| lo_write_data |        | 输入 | W_DATA | 写LO寄存器数据        |
