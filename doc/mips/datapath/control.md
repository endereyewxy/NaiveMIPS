| 信号        |  线号  | 方向 | 位宽 | 描述                   |
| ----------- | :----: | :--: | :--: | ---------------------- |
| ibus        | IF.C.2 | 输入 |  1   | 指令总线的停顿请求     |
| dbus        | MM.C.2 | 输入 |  1   | 数据总线的停顿请求     |
| forward     |        | 输入 |  1   | 前推模块的停顿请求     |
| mulalu      | EX.C.1 | 输入 |  1   | 多周期运算器的停顿请求 |
| except      | MM.C.1 | 输入 |  1   | 异常模块的停顿请求     |
| if_id_stall |        | 输出 |  1   | IF-ID寄存器停顿信号    |
| if_id_flush |        | 输出 |  1   | IF-ID寄存器刷新信号    |
| id_ex_stall |        | 输出 |  1   | ID-EX寄存器停顿信号    |
| id_ex_flush |        | 输出 |  1   | ID-EX寄存器刷新信号    |
| ex_mm_stall |        | 输出 |  1   | EX-MM寄存器停顿信号    |
| ex_mm_flush |        | 输出 |  1   | EX-MM寄存器刷新信号    |
| mm_wb_stall |        | 输出 |  1   | MM-WB寄存器停顿信号    |
| mm_wb_stall |        | 输出 |  1   | MM-WB寄存器刷新信号    |
| pc_stall    | IF.C.1 | 输出 |  1   | PC寄存器的停顿信号     |
| pc_flush    | IF.C.1 | 输出 |  1   | PC寄存器的刷新信号     |

