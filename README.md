# NaiveMIPS

重庆大学硬件综合设计项目。

## 整体架构

![](datapath-1.svg)

其中，Datapath与MMU之间使用虚拟地址，MMU与Cache之间和Cache与SRAM-Like-AXI桥之间使用物理地址，以上三者均使用SRAM-Like接口。而CPU整体对外使用AXI接口，并接受硬件中断。

## 数据通路

![](datapath-2.svg)

- 地址线：用蓝色表示，包含指令或数据的地址，可能包含该地址受否有效；
- 指令线：用紫色表示，包含解码之前或解码之后的指令；
- 数据线：用绿色表示，包含读写的数据，可能包含与之对应的使能和寄存器信息；
- 异常线：用红色表示，包含异常信息；
- 控制线：用黄色表示，包含停顿、刷新等流水线控制信号。

| 代号   | 含义                                     |
| ------ | ---------------------------------------- |
| IF.A.1 | 将要执行的指令地址                       |
| IF.C.1 | 控制PC寄存器的停顿、刷新信号             |
| IF.C.2 | 指令总线发出的停顿请求                   |
| ID.A.1 | 分支指令目标地址，以及该地址的有效性     |
| ID.I.1 | 解码之前的指令                           |
| ID.I.2 | 解码之后的指令                           |
| ID.D.1 | 指令中的立即数（扩展之后）               |
| ID.D.2 | 用于分支判断的寄存器数据（合并前推之后） |
| ID.D.3 | 向ID阶段前推的数据                       |
| ID.D.4 | 寄存器数据（合并前推之前）               |
| ID.E.1 | 指令总线产生的异常                       |
| ID.E.2 | 译码器产生的异常                         |
| ID.E.3 | CP0寄存器提供的中断异常                  |
| EX.D.1 | 向EX阶段前推的数据                       |
| EX.D.2 | ALU操作数                                |
| EX.D.3 | ALU写CP0寄存器（特权指令mtc0）           |
| EX.D.4 | ALU读CP0寄存器（特权指令mfc0）           |
| EX.D.5 | ALU运算结果                              |
| EX.E.1 | ALU产生的异常                            |
| EX.C.1 | 多周期运算器发出的停顿请求               |
| MM.A.1 | 访存地址                                 |
| MM.A.2 | 异常处理入口地址，以及该地址的有效性     |
| MM.D.1 | 访存或写回寄存器的数据                   |
| MM.D.2 | 异常处理写入CP0的数据                    |
| MM.E.1 | 数据总线产生的异常                       |
| MM.C.1 | 异常处理发出的刷新请求                   |
| MM.C.2 | 数据总线发出的停顿请求                   |
| WB.D.1 | 访存得到的数据                           |
| WB.D.2 | 写回寄存器的数据                         |

## 模块设计

注：此处列出的模块仅包含在数据通路中出现的重要模块，具体实现时可根据需要添加模块。

### 顶层模块

| 模块名称         | 源文件路径                  | 文档路径         | 主要功能           | 负责人       |
| ---------------- | --------------------------- | ---------------- | ------------------ | ------------ |
| mips             | src/mips/mips.v             | doc/mips/mips.md | 封装MIPS整体功能   | WXY          |
| sram_like_to_axi | src/mips/sram_like_to_axi.v |                  | 转换SRAM-Like至AXI | 实验环境提供 |
| mmu              | src/mips/mmu.v              | doc/mips/mmu.md  | 实现地址映射       | ZHY/QXF      |
| bus              | src/mips/bus.v              | doc/mips/bus.md  | 实现简单总线接口   | WXY          |
| gpr              | src/mips/gpr.v              | doc/mips/gpr.md  | 实现通用寄存器堆   | ZHY/QXF      |
| cp0              | src/mips/cp0.v              | doc/mips/cp0.md  | 实现CP0寄存器堆    | ZHY/QXF      |

### 缓存模块

| 模块名称      | 源文件路径               | 文档路径                  | 主要功能                   | 负责人 |
| ------------- | ------------------------ | ------------------------- | -------------------------- | ------ |
| cache         | src/mips/cache/cache.v      | doc/mips/cache/cache.md   | 实现缓存整体              | WXY |
| cache_set     | src/mips/cache/cache_set.v  | doc/mips/cache/cache_set.md | 实现缓存组           | WXY |
| cache_line    | src/mips/cache/cache_line.v | doc/mips/cache/cache_line.md | 实现缓存行          | WXY |

### 数据通路

| 模块名称 | 源文件路径                   | 文档路径                      | 主要功能               | 负责人 |
| -------- | ---------------------------- | ----------------------------- | ---------------------- | ------ |
| datapath | src/mips/datapath/datapath.v | doc/mips/datapath/datapath.md | 封装数据通路           | WXY    |
| control  | src/mips/datapath/control.v  | doc/mips/datapath/control.md  | 实现流水线控制器       | WXY    |
| forward  | src/mips/datapath/forward.v  | doc/mips/datapath/forward.md  | 实现流水线数据前推功能 | WXY    |

#### IF阶段

| 模块名称 | 源文件路径                         | 文档路径 | 主要功能     | 负责人 |
| -------- | ---------------------------------- | -------- | ------------ | ------ |
| if | src/mips/datapath/if/if.v | doc/mips/datapath/if/if.md | 封装取值阶段 | ZHY |
| pc       | src/mips/datapath/if/pc.v      | doc/mips/datapath/if/pc.md      | 实现PC寄存器     | ZHY |

#### ID阶段

| 模块名称 | 源文件路径                | 文档路径                   | 主要功能     | 负责人 |
| -------- | ------------------------- | -------------------------- | ------------ | ------ |
| id       | src/mips/datapath/id/id.v | src/mips/datapath/id/id.md | 封装译码阶段 | QXF |
| branch   | src/mips/datapath/id/branch.v  | doc/mips/datapath/id/branch.md  | 处理分支指令 | QXF |
| decode   | src/mips/datapath/id/decode.v  | doc/mips/datapath/id/decode.md  | 实现指令译码     | QXF |
| brcsrc | src/mips/datapath/id/brcsrc.v | doc/mips/datapath/id/brcsrc.md | 准备分支指令处理的操作数 |QXF|

#### EX阶段

| 模块名称 | 源文件路径                         | 文档路径                   | 主要功能     | 负责人 |
| -------- | ---------------------------------- | -------------------------- | ------------ | ------ |
| ex       | src/mips/datapath/ex/ex.v          | doc/mips/datapath/ex/ex.md | 封装执行阶段 | WXY |
| mulalu  | src/mips/datapath/ex/mulalu.v | doc/mips/datapath/ex/mulalu.md | 实现多周期ALU | WXY |
| sglalu | src/mips/datapath/ex/sglalu.v | doc/mips/datapath/ex/sglalu.md | 实现单周期ALU | ZHY |
| alusrc | src/mips/datapath/ex/alusrc.v | doc/mips/datapath/ex/alusrc.md | 准备ALU的操作数 | ZHY |

#### MM阶段

| 模块名称 | 源文件路径                    | 文档路径                       | 主要功能     | 负责人 |
| -------- | ----------------------------- | ------------------------------ | ------------ | ------ |
| mm       | src/mips/datapath/mm/mm.v     | doc/mips/datapath/mm/mm.md     | 封装访存阶段 | WXY    |
| except   | src/mips/datapath/mm/except.v | doc/mips/datapath/mm/except.md | 实现异常处理 | WXY    |
| memctl   | src/mips/datapath/mm/memctl.v | doc/mips/datapath/mm/memctl.md | 控制访存     | ZHY    |

#### WB阶段

| 模块名称 | 源文件路径                    | 文档路径                       | 主要功能             | 负责人 |
| -------- | ----------------------------- | ------------------------------ | -------------------- | ------ |
| wb       | src/mips/datapath/wb/wb.v     | doc/mips/datapath/wb/wb.md     | 封装写回阶段         | QXF    |
| regsrc   | src/mips/datapath/wb/regsrc.v | doc/mips/datapath/wb/regsrc.md | 准备写回寄存器的数据 | QXF    |
