| 信号        | 线号   | 方向 |  位宽  | 描述         |
| ----------- | ------ | :--: | :----: | ------------ |
| clk         |        | 输入 |   1    |              |
| rst         |        | 输入 |   1    |              |
| stall       | IF.C.1 | 输入 |   1    |              |
| except      | MM.A.2 | 输入 |   1    | 异常使能     |
| except_addr | MM.A.2 | 输入 | W_ADDR | 处理异常地址 |
| branch      | ID.A.1 | 输入 |   1    | 分支跳转使能 |
| branch_addr | ID.A.1 | 输入 | W_ADDR | 分支跳转地址 |
| pc_addr     | IF.A.1 | 输出 | W_ADDR | 取指令地址   |


