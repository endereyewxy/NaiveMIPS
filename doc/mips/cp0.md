| 信号名称  | 线号   | 方向 | 位宽   | 描述                               |
| --------- | ------ | ---- | ------ | ---------------------------------- |
| clk       |        | 输入 | 1      | 时钟信号                           |
| rst       |        | 输入 | 1      | 重置信号                           |
| cp0w.en   | MM.D.2 | 输入 | 1      | CP0寄存器写使能                    |
| cp0w.bd   | MM.D.2 | 输入 | 1      | CP0寄存器写数据：CP0.Cause.BD      |
| cp0w.exl  | MM.D.2 | 输入 | 1      | CP0寄存器写数据：CP0.Status.EXL    |
| cp0w.exc  | MM.D.2 | 输入 | W_EXCC | CP0寄存器写数据：CP0.Cause.ExcCode |
| cp0w.epc  | MM.D.2 | 输入 | W_ADDR | CP0寄存器写数据：CP0.EPC           |
| cp0w.bva  | MM.D.2 | 输入 | W_ADDR | CP0寄存器写数据：CP0.BadVAddr      |
| rd.regf   | ID.I.2 | 输入 | W_REGF | 写的寄存器号                       |
| rd.data   | EX.D.3 | 输入 | W_DATA | 要写入CP0寄存器的通用寄存器的数据  |
| rt.regf   | ID.I.2 | 输入 | W_REGF | 读的寄存器号                       |
| rt.data   | EX.D.4 | 输出 | W_DATA | 要写入通用寄存器的CP0寄存器数据    |
| intr_vect | ID.E.3 | 输出 | W_INTV | 中断向量                           |
| er_epc    |        | 输出 | W_ADDR |                                    |

