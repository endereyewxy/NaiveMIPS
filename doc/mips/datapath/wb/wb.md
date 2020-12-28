| 信号名称      |  线号  | 方向 |  位宽  | 描述          |
| ------------- | :----: | :--: | :----: | ------------- |
| clk           |        | 输入 |   1    | 时钟          |
| rst           |        | 输入 |   1    | 重置          |
| stall         |        | 输入 |   1    |               |
| oper_in       | ID.I.2 | 输入 | W_OPER | 指令操作码    |
| write_regf_in | ID.I.2 | 输入 | W_REGF | 写寄存器号    |
| alu_res_in    | MM.D.1 | 输入 | W_DATA | alu运算的结果 |
| oper          | ID.I.2 | 输出 | W_OPER | 指令操作码    |
| write_regf    | ID.I.2 | 输出 | W_REGF | 写寄存器号    |
| alu_res       | MM.D.1 | 输出 | W_DATA | alu运算的结果 |

