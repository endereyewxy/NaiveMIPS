| 信号             |  线号  | 方向 |  位宽  | 描述                               |
| ---------------- | :----: | :--: | :----: | ---------------------------------- |
| clk              |        | 输入 |   1    | 时钟信号                           |
| rst              |        | 输入 |   1    | 重置信号                           |
| intr_vect        | ID.E.2 | 输入 | W_INTV | 中断向量                           |
| er_epc           |        | 输入 | W_ADDR |                                    |
|ibus_sram.en	|	|	输出|1	|	|
| ibus_sram.we |	| 输出 | 4 |	|
| ibus_sram.addr |	| 输出 | W_ADDR |	|
| ibus_sram.data_w |	| 输出 | W_DATA |	|
| ibus_sram.data_r |	| 输入 | W_DATA |	|
| dbus_sram.stall |	| 输入 | 1 |	|
|dbus_sram.en	|	|	输出|1	|	|
| dbus_sram.we |	| 输出 | 4 |	|
| dbus_sram.addr |	| 输出 | W_ADDR |	|
| dbus_sram.data_w |	| 输出 | W_DATA |	|
| dbus_sram.data_r |	| 输入 | W_DATA |	|
| dbus_sram.stall |	| 输入 | 1 |	|
| ibus_error.adel |        | 输入 |   1    |                                     |
| ibus_error.ades |        | 输入 |   1    |                                     |
| ibus_error.addr |        | 输入 | W_ADDR |                                     |
| dbus_error.adel |        | 输入 |   1    |                                     |
| dbus_error.ades |        | 输入 |   1    |                                     |
| dbus_error.addr |        | 输入 | W_ADDR |                                     |
| cp0w_error.we  | MM.D.2 | 输出 |   1    | CP0寄存器写使能                     |
| cp0w_error.bd  | MM.D.2 | 输出 |   1    | CP0寄存器写数据：CP0.Cause.BD       |
| cp0w_error.exl | MM.D.2 | 输出 |   1    | CP0寄存器写数据：CP0.Status.EXL     |
| cp0w_errorexc | MM.D.2 | 输出 | W_EXCC | CP0寄存器写数据：CP0.Cause.ExcCode  |
| cp0w_error.epc | MM.D.2 | 输出 | W_ADDR | CP0寄存器写数据：CP0.EPC            |
| cp0w_error.bva | MM.D.2 | 输出 | W_ADDR | CP0寄存器写数据：CP0.BadVAddr       |
| cp0_rt.regf |	| 输出 | W_REGF |	|
| cp0_rt.data |	| 输入 | W_DATA |	|
| cp0_rd.regf |	| 输出 | W_REGF |	|
| cp0_rd.data |	| 输出 | W_DATA |	|
| rs.regf |	| 输出 | W_REGF |	|
| rs.data |	| 输入 | W_DATA |	|
| rt.regf |	| 输出 | W_REGF |	|
| rt.data |	| 输入 | W_DATA |	|
| rd.regf |	| 输出 | W_REGF |	|
| rd.data |	| 输出 | W_DATA |	|
| debug.debug_wb_pc |	| 输出 | W_DATA |	|
| debug.debug_wb_rf_wen |	| 输出 | 4 |	|
| debug.debug_wb_rf_wnum |	| 输出 | W_REGF |	|
| debug.debug_wb_rf_wdata |	| 输出 | W_DATA |	|