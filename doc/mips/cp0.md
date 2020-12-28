| 信号名称  | 线号   | 方向 | 位宽   | 描述                               |
| --------- | ------ | ---- | ------ | ---------------------------------- |
| cp0       | MM.D.2 | 输入 | 1      | CP0寄存器写使能                    |
| cp0_exl   | MM.D.2 | 输入 | 1      | CP0寄存器写数据：CP0.Status.EXL    |
| cp0_exc   | MM.D.2 | 输入 | W_EXCC | CP0寄存器写数据：CP0.Cause.ExcCode |
| cp0_epc   | MM.D.2 | 输入 | W_ADDR | CP0寄存器写数据：CP0.EPC           |
| cp0_bva   | MM.D.2 | 输入 | W_ADDR | CP0寄存器写数据：CP0.BadVAddr      |
| cp0_bd    | MM.D.2 | 输入 | 1      | CP0寄存器写数据：CP0.Cause.BD      |
| cp0_in    | EX.D.3 | 输入 | W_DATA | 要写入CP0寄存器的通用寄存器的数据  |
| cp0_out   | EX.D.4 | 输出 | W_DATA | 要写入通用寄存器的CP0寄存器数据    |
| intr_vect | ID.E.3 | 输出 | W_INTV | 中断向量                           |

