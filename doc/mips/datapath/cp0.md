# CP0寄存器堆

限制：

- 写入数据在同一个周期内（立即）有效。

### 时钟及复位

| 信号       | 方向 | 位宽   | 描述             |
| ---------- | ---- | ------ | ---------------- |
| clk        | 输入 | 1      | 时钟             |
| rst        | 输入 | 1      | 复位             |

### 通用读

| 信号       | 方向 | 位宽   | 描述             |
| ---------- | ---- | ------ | ---------------- |
| read_regf  | 输入 | W_REGF | 要读的寄存器号   |
| read_data  | 输出 | W_DATA | 第二个读到的数据 |

### 通用写

| 信号       | 方向 | 位宽   | 描述             |
| ---------- | ---- | ------ | ---------------- |
| read_data  | 输出 | W_DATA | 第二个读到的数据 |
| write      | 输入 | 1      | 写使能           |
| write_regf | 输入 | W_REGF | 要写的寄存器号   |
| write_data | 输入 | W_DATA | 要写的数据       |

### 特殊读

| 信号      | 方向 | 位宽   | 描述                     |
| --------- | ---- | ------ | ------------------------ |
| bad_vaddr | 输出 | W_DATA | 对应特殊寄存器的值，下同 |
| status    | 输出 | W_DATA |                          |
| cause     | 输出 | W_DATA |                          |
| epc       | 输出 | W_DATA |                          |

### 特殊写

| 信号                 | 方向 | 位宽   | 描述                                         |
| -------------------- | ---- | ------ | -------------------------------------------- |
| bad_vaddr_write      | 输入 | 1      | BadVAddr写使能                               |
| bad_vaddr_write_data |      | W_DATA | BadVAddr写数据                               |
| status_write_mask    |      | W_DATA | Status写掩码（只写部分位），高电平有效，下同 |
| status_write_data    |      | W_DATA | Status写数据                                 |
| cause_write_mask     |      | W_DATA | Cause写掩码                                  |
| cause_write_data     |      | W_DATA | Cause写数据                                  |
| epc_write            |      | 1      | EPC写使能                                    |
| epc_write_data       |      | W_DATA | EPC写数据                                    |