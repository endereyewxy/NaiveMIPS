| 信号        |  线号  | 方向 |  位宽  | 描述                         |
| ----------- | :----: | :--: | :----: | ---------------------------- |
| oper        | ID.I.2 | 输入 | W_OPER | 指令操作码                   |
| source_addr | EX.D.5 | 输入 | W_ADDR | 访存地址（运算器的计算结果） |
| source_data | EX.D.2 | 输入 | W_DATA | 访存数据                     |
| dbus_en     | MM.A.1 | 输出 |   1    | 访存使能                     |
| dbus_we     | MM.A.1 | 输出 |   4    | 访存读写控制信号             |
| dbus_size   |        | 输出 |   2    | 访存字节数                   |
| dbus_addr   | MM.A.1 | 输出 | W_ADDR | 访存地址                     |
| dbus_data   | MM.D.1 | 输出 | W_ADDR | 访存数据                     |

