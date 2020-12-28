| 信号        |  线号  | 方向 | 位宽 | 描述                          |
| ----------- | :----: | :--: | :--: | ----------------------------- |
| ibus        | IF.C.2 | 输入 |  1   |                               |
| dbus        | MM.C.2 | 输入 |  1   |                               |
| forward     |        | 输入 |  1   | 前推模块的停顿请求            |
| mulalu      | EX.C.1 | 输入 |  1   |                               |
| except      | MM.C.1 | 输入 |  1   |                               |
| if_id_stall |        | 输出 |  1   | IF-ID寄存器停顿信号，之后类似 |
| if_id_flush |        | 输出 |  1   | IF-ID寄存器刷新信号，之后类似 |
| id_ex_stall |        | 输出 |  1   |                               |
| id_ex_flush |        | 输出 |  1   |                               |
| ex_mm_stall |        | 输出 |  1   |                               |
| ex_mm_flush |        | 输出 |  1   |                               |
| mm_wb_stall |        | 输出 |  1   |                               |
| mm_wb_stall |        | 输出 |  1   |                               |
| pc_stall    | IF.C.1 | 输出 |  1   |                               |
| pc_flush    | IF.C.1 | 输出 |  1   |                               |

