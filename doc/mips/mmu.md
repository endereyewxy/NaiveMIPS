| 信号名称      | 线号 | 方向 | 位宽   | 描述 |
| ------------- | ---- | ---- | ------ | ---- |
| ibus_v.en     |      | 输入 | 1      |      |
| ibus_v.we     |      | 输入 | [3:0]  |      |
| ibus_v.addr   |      | 输入 | W_ADDR |      |
| ibus_v.data_w |      | 输入 | W_DATA |      |
| ibus_v.data_r |      | 输出 | W_DATA |      |
| ibus_v.stall  |      | 输出 | 1      |      |
| dbus_v.en     |      | 输入 | 1      |      |
| dbus_v.we     |      | 输入 | [3:0]  |      |
| dbus_v.addr   |      | 输入 | W_ADDR |      |
| dbus_v.data_w |      | 输入 | W_DATA |      |
| dbus_v.data_r |      | 输出 | W_DATA |      |
| dbus_v.stall  |      | 输出 | 1      |      |
| ibus_p.en     |      | 输出 | 1      |      |
| ibus_p.we     |      | 输出 | [3:0]  |      |
| ibus_p.addr   |      | 输出 | W_ADDR |      |
| ibus_p.data_w |      | 输出 | W_DATA |      |
| ibus_p.data_r |      | 输入 | W_DATA |      |
| ibus_p.stall  |      | 输入 | 1      |      |
| dbus_p.en     |      | 输出 | 1      |      |
| dbus_p.we     |      | 输出 | [3:0]  |      |
| dbus_p.addr   |      | 输出 | W_ADDR |      |
| dbus_p.data_w |      | 输出 | W_DATA |      |
| dbus_p.data_r |      | 输入 | W_DATA |      |
| dbus_p.stall  |      | 输入 | 1      |      |
| no_dcache     |      | 输出 | 1      |      |

