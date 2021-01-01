| 信号名称    |  线号  |  方向  |  位宽  | 描述                                |
| ----------- | :----: | :----: | :----: | ----------------------------------- |
| oper        | ID.I.2 |  输入  | W_OPER | 指令操作码                          |
| slot        | ID.I.2 |  输入  |   1    | 当前指令是否在延迟槽中              |
| pc          | IF.A.1 |  输入  | W_ADDR | 发生例外的指令PC |
| ibus_error.adel |        | 输入 |   1    | ibus中load指令触发地址错例外 |
| ibus_error.ades |        | 输入 |   1    | ibus中store指令触发地址错例外 |
| ibus_error.addr |        | 输入 | W_ADDR | ibus中地址错例外的地址 |
| dbus_error.adel |        | 输入 |   1    | dbus中load指令触发地址错例外 |
| dbus_error.ades |        | 输入 |   1    | dbus中store指令触发地址错例外 |
| dbus_error.addr |        | 输入 | W_ADDR | dbus中地址错例外的地址 |
| exec_error.intr_vect | ID.E.3 | 输入 | W_INTV | 中断向量                            |
| exec_error.sy  | ID.E.2 | 输入 |   1    | 内陷指令异常：SYSCALL               |
| exec_error.bp  | ID.E.2 | 输入 |   1    | 内陷指令异常：BREAK                 |
| exec_error.ri  | ID.E.2 | 输入 |   1    | 未实现指令异常                      |
| exec_error.ov  | EX.E.1 | 输入 |   1    | 运算器溢出异常                      |
| exec_error.er | ID.E.2 | 输入 |   1    | 内陷指令异常：ERET                  |
| exec_error.er_epc | ID.E.2 | 输入 | W_ADDR | 内陷指令异常：ERET附加的CP0.EPC的值 |
| cp0w_error.we  | MM.D.2 | 输出 |   1    | CP0寄存器写使能                     |
| cp0w_error.bd  | MM.D.2 | 输出 |   1    | CP0寄存器写数据：CP0.Cause.BD       |
| cp0w_error.exl | MM.D.2 | 输出 |   1    | CP0寄存器写数据：CP0.Status.EXL     |
| cp0w_errorexc | MM.D.2 | 输出 | W_EXCC | CP0寄存器写数据：CP0.Cause.ExcCode  |
| cp0w_error.epc | MM.D.2 | 输出 | W_ADDR | CP0寄存器写数据：CP0.EPC            |
| cp0w_error.bva | MM.D.2 | 输出 | W_ADDR | CP0寄存器写数据：CP0.BadVAddr       |
| except      | MM.A.2 |  输出  |   1    | 异常处理入口地址的有效性            |
| except_addr | MM.A.2 |  输出  | W_ADDR | 异常处理入口地址                    |
| source_addr | EX.D.5 | 输入 | W_ADDR | 访存地址（运算器的计算结果） |
| source_data | EX.D.2 | 输入 | W_DATA | 访存数据                     |
| dbus_en     | MM.A.1 | 输出 |   1    | 访存使能                     |
| dbus_we     | MM.A.1 | 输出 |   4    | 访存读写控制信号             |
| dbus_addr   | MM.A.1 | 输出 | W_ADDR | 访存地址                     |
| dbus_data   | MM.D.1 | 输出 | W_ADDR | 访存数据                     |
| word_offset |  | 输出 |   2    | 访存的字节数            |
