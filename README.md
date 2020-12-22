# NaiveMIPS

重庆大学硬件综合设计项目。

## 规范与约定

### 路径

- src目录存放所有源文件（包括扩展名为`.v`和`.vh`的文件，其中`.vh`文件存放在src/includes/目录下）；
- sim目录存放所有与测试相关的文件，包括测试代码源文件（扩展名为`.v`），测试用的汇编代码（扩展名为`.S`）和ROM/RAM初始化文件（扩展名为`.coe`），每个测试单独一个文件夹；
- doc目录存放所有文档，格式为Markdown。
- Vivado产生的文件（包括扩展名`.xpr`的工程文件）存放位置随意，但**不要推送到Github！！！**你可以在.gitignore里面屏蔽它们。

### 模块

- 模块名使用小写字母加下划线，模块的输入输出信号名也使用小写字母加下划线，模块的输入输出信号位宽尽量使用常量（比如W_REGF，W_ADDR，W_DATA）；
- 每个模块都必须拥有一个与之对应的文档，描述这个模块的输入输出信号定义，一些备注，当前存在的问题等，存放路径格式与源文件相同（但在doc目录下）；
- 如果一个模块比较复杂，那么可以单独为它写一个测试，测试用到的代码和其它文件存放路径格式与源文件相同（但在`sim`目录下）；
- 代码统一用四个空格（**不要用Tab！！！**）缩进，其余格式随意，但同一个模块的代码风格最好一致（参考实验环境给出的）。

### 分支

- 每个模块单独分配一个分支，名字为*dev-<模块名，但下划线变成中横线>*，例如模块stage_d使用分支dev-stage-d；
- 该模块的源文件、测试文件和文档都属于这个分支；
- 当模块的输入输出信号定义完成（但还没有实现）时，合并到主分支；
- 当模块的功能实现完成，并且通过单元测试（如果有的话）时，再次合并到主分支；
- 如果发现Bug，先在模块自己的分支内修改，测试通过之后，再合并到主分支。

### 语言

- Git的提交信息使用中文，描述清楚这次提交干了什么；
- 注释中英文随意，但请确保语法是对的并且别人能看懂。

## 整体架构

### 顶层模块

| 模块名称 | 源文件路径 | 文档路径    | 主要功能             | 负责人 |
| -------- | ---------- | ----------- | -------------------- | ------ |
| mips     | src/mips.v | src/mips.md | 封装MIPS CPU整体功能 |        |

### 桥接模块

| 模块名称         | 源文件                        | 文档路径 | 主要功能           | 负责人       |
| ---------------- | ----------------------------- | -------- | ------------------ | ------------ |
| sram_like_to_axi | src/bridge/sram_like_to_axi.v |          | 转换SRAM-Like至AXI | 实验环境提供 |



### 缓存模块

| 模块名称      | 源文件路径               | 文档路径                  | 主要功能                   | 负责人 |
| ------------- | ------------------------ | ------------------------- | -------------------------- | ------ |
| cache         | src/mips/cache/cache.v      | src/mips/cache/cache.md      | 实现Cache                  |        |
| cache_set     | src/mips/cache/cache_set.v  | src/mips/cache/cache_set.md  | 实现Cache Set              |        |
| cache_line    | src/mips/cache/cache_line.v | src/mips/cache/cache_line.md | 实现Cache Line             |        |

### 数据通路外部模块

| 模块名称      | 源文件路径               | 文档路径                  | 主要功能                   | 负责人 |
| ------------- | ------------------------ | ------------------------- | -------------------------- | ------ |
| mmu           | src/mips/mmu.v           | src/mips/mmu.md           | 提供虚地址到物理地址的映射 |        |
| bus           | src/mips/bus.v           | src/mips/bus.md           | 提供总线接口               |        |
| register_file | src/mips/register_file.v | src/mips/register_file.md | 实现寄存器堆               |        |

### 数据通路内部模块

| 模块名称 | 源文件路径                     | 文档路径                        | 主要功能           | 阶段 | 负责人 |
| -------- | ------------------------------ | ------------------------------- | ------------------ | ---- | ------ |
| datapath | src/mips/datapath/datapath.v   | src/mips/datapath/datapath.md   | 实现总体数据通路   |      |        |
| control  | src/mips/datapath/controller.v | src/mips/datapath/controller.md | 提供流水线控制功能 |      |        |
| if       | src/mips/datapath/if/if.v      | src/mips/datapath/if/if.md      | 实现取指阶段       | IF   |        |
| id       | src/mips/datapath/id/id.v      | src/mips/datapath/id/id.md      | 实现译码阶段       | ID   |        |
| ex       | src/mips/datapath/ex/ex.v      | src/mips/datapath/ex/ex.md      | 实现执行阶段       | EX   |        |
| mm       | src/mips/datapath/mm/mm.v      | src/mips/datapath/mm/mm.md      | 实现访存阶段       | MM   |        |
| wb       | src/mips/datapath/wb/wb.v      | src/mips/datapath/wb/wb.md      | 实现写回阶段       | WB   |        |
| pc       | src/mips/datapath/if/pc.v      | src/mips/datapath/if/pc.md      | 实现PC寄存器       | IF   |        |
| branch   | src/mips/datapath/id/branch.v  | src/mips/datapath/id/branch.md  | 实现跳转处理       | ID   |        |
| decode   | src/mips/datapath/id/decode.v  | src/mips/datapath/id/decode.md  | 实现指令译码       | ID   |        |
| complex  | src/mips/datapath/ex/complex.v | src/mips/datapath/ex/complex.md | 实现多周期运算器   | EX   |        |
| execute  | src/mips/datapath/ex/execute.v | src/mips/datapath/ex/execute.md | 实现单周期运算器   | EX   |        |
| except   | src/mips/datapath/mm/except.v  | src/mips/datapath/mm/except.md  | 实现异常处理       | MM   |        |

## 数据通路图

![](datapath-1.svg)

![](datapath-2.svg)

其中蓝色线代表地址，绿色线代表数据，紫色线代表指令，黄色线代表控制信号，红色线代表异常信号。各线的代号格式为*阶段.类型.标号*，如IF.A.1表示IF阶段第一条地址线，MM.E.4表示MM阶段第四条异常信号线。

| 代号   | 含义                                 |
| ------ | ------------------------------------ |
| IF.A.1 | 异常处理入口地址                     |
| IF.A.2 | 跳转目标地址                         |
| IF.A.3 | 当前PC寄存器的值                     |
| IF.C.1 | PC寄存器控制信号                     |
| IF.C.2 | 指令总线停顿信号                     |
| ID.A.1 | 上一阶段的IF.A.3                     |
| ID.D.1 | 前推数据                             |
| ID.D.2 | 读寄存器得到的数据                   |
| ID.D.3 | 实际的寄存器数据（考虑前推）         |
| ID.I.1 | 当前指令                             |
| ID.C.1 | 指令解码得到的控制信号               |
| ID.E.1 | 指令总线异常信号                     |
| EX.A.1 | 运算器生成的，访存的地址             |
| EX.D.1 | 上一阶段的ID.D.3                     |
| EX.D.2 | 运算器生成的，访存或写回寄存器的数据 |
| EX.C.1 | 上一阶段的ID.C.1                     |
| EX.C.2 | 多周期运算器的停顿信号               |
| EX.E.1 | 上一阶段的ID.E.1                     |
| EX.E.2 | 处理器生成的错误信号                 |
| MM.A.1 | 上一阶段的EX.A.1                     |
| MM.D.1 | 上一阶段的EX.D.2                     |
| MM.C.1 | 上一阶段的EX.C.1                     |
| MM.C.2 | 数据总线的停顿信号                   |
| MM.E.1 | 上一阶段的EX.E.2                     |
| MM.E.2 | 上一阶段的EX.E.1                     |
| MM.E.3 | 数据总线的错误信号                   |
| MM.E.4 | 报告控制器的错误信号                 |
| WB.D.1 | 上一阶段的MM.D.1                     |
| WB.D.2 | 前推数据                             |
| WB.D.3 | 访存结果数据                         |
| WB.D.4 | 写回寄存器的数据                     |
| WB.C.1 | 上一阶段的MM.C.1                     |

