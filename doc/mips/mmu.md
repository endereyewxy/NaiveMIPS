| 信号名称      | 线号 | 方向 | 位宽   | 描述                                |
| ------------- | ---- | ---- | ------ | ----------------------------------- |
| ibus_v.en     |      | 输入 | 1      | ibus_v访存使能                      |
| ibus_v.we     |      | 输入 | 4      | ibus_v读写控制信号                  |
| ibus_v.size   |      | 输入 | 2      |                                     |
| ibus_v.addr   |      | 输入 | W_ADDR | ibus_v访存地址                      |
| ibus_v.data_w |      | 输入 | W_DATA | ibus_v寄存器写的值                  |
| ibus_v.data_r |      | 输出 | W_DATA | ibus_v寄存器读的值                  |
| ibus_v.stall  |      | 输出 | 1      | ibus_v停止控制                      |
| dbus_v.en     |      | 输入 | 1      | dbus_v访存使能                      |
| dbus_v.we     |      | 输入 | 4      | dbus_v读写控制信号                  |
| dbus_v.size   |      | 输入 | 2      |                                     |
| dbus_v.addr   |      | 输入 | W_ADDR | dbus_v访存地址                      |
| dbus_v.data_w |      | 输入 | W_DATA | ibus_v寄存器写的值                  |
| dbus_v.data_r |      | 输出 | W_DATA | ibus_v寄存器读的值                  |
| dbus_v.stall  |      | 输出 | 1      | dbus_v停止控制                      |
| ibus_p.en     |      | 输出 | 1      | ibus_p访存使能                      |
| ibus_p.we     |      | 输出 | 4      | ibus_p读写控制信号                  |
| ibus_p.size   |      | 输出 | 2      |                                     |
| ibus_p.addr   |      | 输出 | W_ADDR | ibus_p访存地址                      |
| ibus_p.data_w |      | 输出 | W_DATA | ibus_p寄存器写的值                  |
| ibus_p.data_r |      | 输入 | W_DATA | ibus_p寄存器读的值                  |
| ibus_p.stall  |      | 输入 | 1      | ibus_p停止控制                      |
| dbus_p.en     |      | 输出 | 1      | dbus_p访存使能                      |
| dbus_p.we     |      | 输出 | 4      | dbus_p读写控制信号                  |
| dbus_p.size   |      | 输出 | 2      |                                     |
| dbus_p.addr   |      | 输出 | W_ADDR | dbus_p访存地址                      |
| dbus_p.data_w |      | 输出 | W_DATA | dbus_p寄存器写的值                  |
| dbus_p.data_r |      | 输入 | W_DATA | dbus_p寄存器读的值                  |
| dbus_p.stall  |      | 输入 | 1      | dbus_p停止控制                      |
| ibus_e.adel   |      | 输出 | 1      | ibus_e中load指令是否触发地址错例外  |
| ibus_e.ades   |      | 输出 | 1      | ibus_e中store指令是否触发地址错例外 |
| ibus_e.addr   |      | 输出 | W_ADDR | ibus_e中地址错例外的地址            |
| dbus_e.adel   |      | 输出 | 1      | dbus_e中load指令是否触发地址错例外  |
| dbus_e.ades   |      | 输出 | 1      | dbus_e中store指令是否触发地址错例外 |
| dbus_e.addr   |      | 输出 | W_ADDR | dbus_e中地址错例外的地址            |
| no_dcache     |      | 输出 | 1      | 是否经过dcache                      |

