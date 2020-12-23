# NaiveMIPS

重庆大学硬件综合设计项目。

## 整体架构

![](datapath-1.svg)

其中，Datapath与MMU之间使用虚拟地址，MMU与Cache之间和Cache与SRAM-Like-AXI桥之间使用物理地址，以上三者均使用SRAM-Like接口。而CPU整体对外使用AXI接口，并接受硬件中断。

## 数据通路

![](datapath-2.svg)

其中蓝色线代表地址，绿色线代表数据，紫色线代表指令，黄色线代表控制信号，红色线代表异常信号。各线的代号格式为*阶段.类型.标号*，如IF.A.1表示IF阶段第一条地址线，MM.E.4表示MM阶段第四条异常信号线。

| 代号   | 含义                                                     |
| ------ | -------------------------------------------------------- |
| IF.A.1 | （可能存在的）异常处理入口地址                           |
| IF.A.2 | （可能存在的）分支跳转目标地址                           |
| IF.A.3 | 指令地址                                                 |
| IF.C.1 | PC寄存器控制信号                                         |
| IF.C.2 | 指令总线发出的停顿请求                                   |
| ID.A.1 | 指令地址                                                 |
| ID.D.1 | 来自之后阶段的前推数据                                   |
| ID.D.2 | （可能的存在的）读寄存器数据                             |
| ID.D.3 | 合并前推数据后的读寄存器数据                             |
| ID.I.1 | 当前指令                                                 |
| ID.C.1 | 指令解码得到的控制信号                                   |
| ID.E.1 | 指令总线的AdEL，以及寄存器提供的当前中断（考虑屏蔽之后） |
| EX.A.1 | 运算器生成的，访存的地址                                 |
| EX.D.1 | 运算器操作数                                             |
| EX.D.2 | 运算器生成的，访存或写回寄存器的数据                     |
| EX.C.1 | 指令解码得到的控制信号                                   |
| EX.C.2 | 多周期运算器的停顿信号                                   |
| EX.E.1 | 指令总线的AdEL，以及寄存器提供的当前中断（考虑屏蔽之后） |
| EX.E.2 | 内陷指令、未实现指令和溢出错误                           |
| MM.A.1 | 访存的地址                                               |
| MM.D.1 | 访存或写回寄存器的数据                                   |
| MM.C.1 | 指令解码得到的控制信号                                   |
| MM.C.2 | 数据总线发出的停顿请求                                   |
| MM.E.1 | 指令总线的AdEL，以及寄存器提供的当前中断（考虑屏蔽之后） |
| MM.E.2 | 内陷指令、未实现指令和溢出错误                           |
| MM.E.3 | 数据总线的AdEL，AdES                                     |
| MM.E.4 | 报告控制器的错误信号                                     |
| WB.D.1 | 写回寄存器的数据的可能来源之一（来自运算器）             |
| WB.D.2 | 写回寄存器的数据的可能来源之二（来自访存结果）           |
| WB.D.3 | 写回寄存器的数据                                         |
| WB.C.1 | 指令解码得到的控制信号                                   |

## 模块设计

### 顶层模块

| 模块名称         | 源文件路径                  | 文档路径         | 主要功能           | 负责人       |
| ---------------- | --------------------------- | ---------------- | ------------------ | ------------ |
| mips             | src/mips/mips.v             | doc/mips/mips.md | 封装MIPS整体功能   |              |
| sram_like_to_axi | src/mips/sram_like_to_axi.v |                  | 转换SRAM-Like至AXI | 实验环境提供 |
| mmu              | src/mips/mmu.v              | doc/mips/mmu.md  | 实现地址映射       |              |
| bus              | src/mips/bus.v              | doc/mips/bus.md  | 提供总线接口       |              |

### 缓存模块

| 模块名称      | 源文件路径               | 文档路径                  | 主要功能                   | 负责人 |
| ------------- | ------------------------ | ------------------------- | -------------------------- | ------ |
| cache         | src/mips/cache/cache.v      | doc/mips/cache/cache.md   | 实现缓存整体              |        |
| cache_set     | src/mips/cache/cache_set.v  | doc/mips/cache/cache_set.md | 实现缓存组           |        |
| cache_line    | src/mips/cache/cache_line.v | doc/mips/cache/cache_line.md | 实现缓存行          |        |

### 数据通路

| 模块名称      | 源文件路径                        | 文档路径                           | 主要功能     | 阶段 | 负责人 |
| ------------- | --------------------------------- | ---------------------------------- | ------------ | ---- | ------ |
| datapath      | src/mips/datapath/datapath.v      | doc/mips/datapath/datapath.md      | 实现数据通路 |      |        |
| control       | src/mips/datapath/controller.v    | doc/mips/datapath/controller.md    | 控制流水线   |      |        |
| register_file | src/mips/datapath/register_file.v | doc/mips/datapath/register_file.md | 实现寄存器堆 |      |        |

#### IF阶段

| 模块名称 | 源文件路径                         | 文档路径 | 主要功能     | 负责人 |
| -------- | ---------------------------------- | -------- | ------------ | ------ |
| pc       | src/mips/datapath/if/pc.v      | doc/mips/datapath/if/pc.md      | 实现PC寄存器     |        |

#### ID阶段

| 模块名称 | 源文件路径                | 文档路径                   | 主要功能     | 负责人 |
| -------- | ------------------------- | -------------------------- | ------------ | ------ |
| id       | src/mips/datapath/id/id.v | src/mips/datapath/id/id.md | 实现译码阶段 |        |
| branch   | src/mips/datapath/id/branch.v  | doc/mips/datapath/id/branch.md  | 实现跳转处理     |        |
| decode   | src/mips/datapath/id/decode.v  | doc/mips/datapath/id/decode.md  | 实现指令译码     |        |
| reg_mux | src/mips/datapath/id/reg_mux.v| doc/mips/datapath/id/reg_mux.md | 合并寄存器数据与前推数据 |

#### EX阶段

| 模块名称 | 源文件路径                         | 文档路径                   | 主要功能     | 负责人 |
| -------- | ---------------------------------- | -------------------------- | ------------ | ------ |
| ex       | src/mips/datapath/ex/ex.v          | doc/mips/datapath/ex/ex.md | 实现执行阶段 |        |
| complex  | src/mips/datapath/ex/complex.v | doc/mips/datapath/ex/complex.md | 实现多周期运算器 |        |
| execute  | src/mips/datapath/ex/execute.v | doc/mips/datapath/ex/execute.md | 实现单周期运算器 |        |

#### MM阶段

| 模块名称 | 源文件路径                     | 文档路径                        | 主要功能         | 负责人 |
| -------- | ------------------------------ | ------------------------------- | ---------------- | ------ |
| except   | src/mips/datapath/mm/except.v  | doc/mips/datapath/mm/except.md  | 实现异常处理     |        |

#### WB阶段

| 模块名称 | 源文件路径                     | 文档路径                        | 主要功能         | 负责人 |
| -------- | ------------------------------ | ------------------------------- | ---------------- | ------ |
| wb       | src/mips/datapath/wb/wb.v      | doc/mips/datapath/wb/wb.md      | 实现写回阶段     |        |
