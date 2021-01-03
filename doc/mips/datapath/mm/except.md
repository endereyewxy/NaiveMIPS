| 信号名称       |  线号  | 方向 |  位宽  | 描述                                |
| -------------- | :----: | :--: | :----: | ----------------------------------- |
| slot           | ID.I.2 | 输入 |   1    | 当前指令是否在延迟槽中              |
| pc             | IF.A.1 | 输入 | W_ADDR | 发生例外的指令PC                    |
| ibus.adel      |        | 输入 |   1    | ibus中load指令是否触发地址错例外    |
| ibus.ades      |        | 输入 |   1    | ibus中store指令是否触发地址错例外   |
| ibus.addr      |        | 输入 | W_ADDR | ibus中地址错例外的地址              |
| dbus.adel      |        | 输入 |   1    | dbus中load指令是否触发地址错例外    |
| dbus.ades      |        | 输入 |   1    | dbus中store指令是否触发地址错例外   |
| dbus.addr      |        | 输入 | W_ADDR | dbus中地址错例外的地址              |
| exec.intr_vect | ID.E.3 | 输入 | W_INTV | 中断向量                            |
| exec.sy        | ID.E.2 | 输入 |   1    | 内陷指令异常：SYSCALL               |
| exec.bp        | ID.E.2 | 输入 |   1    | 内陷指令异常：BREAK                 |
| exec.ri        | ID.E.2 | 输入 |   1    | 未实现指令异常                      |
| exec.ov        | EX.E.1 | 输入 |   1    | 运算器溢出异常                      |
| exec.er        | ID.E.2 | 输入 |   1    | 内陷指令异常：ERET                  |
| exec.er_epc    | ID.E.2 | 输入 | W_ADDR | 内陷指令异常：ERET附加的CP0.EPC的值 |
| cp0w.we        | MM.D.2 | 输出 |   1    | CP0寄存器写使能                     |
| cp0w.bd        | MM.D.2 | 输出 |   1    | CP0寄存器写数据：CP0.Cause.BD       |
| cp0w.exl       | MM.D.2 | 输出 |   1    | CP0寄存器写数据：CP0.Status.EXL     |
| cp0w.exc       | MM.D.2 | 输出 | W_EXCC | CP0寄存器写数据：CP0.Cause.ExcCode  |
| cp0w.epc       | MM.D.2 | 输出 | W_ADDR | CP0寄存器写数据：CP0.EPC            |
| cp0w.bva       | MM.D.2 | 输出 | W_ADDR | CP0寄存器写数据：CP0.BadVAddr       |
| except         | MM.A.2 | 输出 |   1    | 异常处理入口地址的有效性            |
| except_addr    | MM.A.2 | 输出 | W_ADDR | 异常处理入口地址                    |
