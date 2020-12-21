| 参数    | 描述           |
| ------- | -------------- |
| `WIDTH` | 输入输出的位宽 |

| 信号  | 方向 | 位宽    |
| ----- | ---- | ------- |
| sel   | 输入 | 1       |
| src_a | 输入 | `WIDTH` |
| src_b | 输入 | `WIDTH` |
| src_c | 输入 | `WIDTH` |
| src_d | 输入 | `WIDTH` |
| out   | 输出 | `WIDTH` |

- 如果`sel`等于`0`，`out`等于`src_a`；
- 如果`sel`等于`1`，`out`等于`src_b`；
- 如果`sel`等于`2`，`out`等于`src_c`；
- 如果`sel`等于`3`，`out`等于`src_d`；