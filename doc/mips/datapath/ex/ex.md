| 信号名称        |  线号  | 方向 |  位宽  | 描述                       |
| --------------- | :----: | :--: | :----: | -------------------------- |
| clk             |        | 输入 |   1    | 时钟                       |
| rst             |        | 输入 |   1    | 复位                       |
| reg_stall       |        | 输入 |   1    | ID-EX间寄存器停顿信号      |
| reg_flush       |        | 输入 |   1    | ID-EX间寄存器刷新信号      |
| alu_stall       | EX.C.1 | 输出 |   1    | 多周期运算器停顿请求       |
| ityp            | ID.I.2 | 输入 | W_TYPE | 指令类型                   |
| oper            | ID.I.2 | 输入 | W_OPER | 操作码                     |
| func            | ID.I.2 | 输入 | W_FUNC | 运算码                     |
| imme            | ID.D.1 | 输入 | W_DATA | 扩展之后的立即数           |
| forward_rs      | EX.D.1 | 输入 |   1    | 第一个源寄存器前推的有效性 |
| forward_rs_data | EX.D.1 | 输入 | W_DATA | 第一个源寄存器前推的值     |
| forward_rt      | EX.D.1 | 输入 |   1    | 第二个源寄存器前推的有效性 |
| forward_rt_data | EX.D.1 | 输入 | W_DATA | 第二个源寄存器前推的值     |
| rs_data         | ID.D.4 | 输入 | W_DATA | 第一个源寄存器值           |
| rt_data         | ID.D.4 | 输入 | W_DATA | 第二个源寄存器值           |
| cp0_rt_data     | EX.D.4 | 输入 | W_DATA | 要读取的CP0寄存器值        |
| cp0_rd_data     | EX.D.3 | 输出 | W_DATA | 要写入的CP0寄存器值        |
| result          | EX.D.5 | 输出 | W_DATA | 运算结果                   |
| ov              | EX.E.1 | 输出 |   1    | 运算器溢出异常             |
| source_data     |        | 输出 | W_DATA | 控制访存                   |
