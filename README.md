# NaiveMIPS

重庆大学硬件综合设计项目。

## 规范与约定

### 路径

- `src`目录存放所有源文件（包括扩展名为`.v`和`.vh`的文件，其中`.vh`文件存放在`src/includes/`目录下）；
- `sim`目录存放所有与测试相关的文件，包括测试代码源文件（扩展名为`.v`），测试用的汇编代码（扩展名为`.S`）和ROM初始化文件（扩展名为`.coe`），每个测试单独一个文件夹；
- `doc`目录存放所有文档，格式为Markdown。
- Vivado产生的文件（包括扩展名`.xpr`的工程文件）存放位置随意，但**不要推送到Github！！！**你可以在`.gitignore`里面屏蔽它们。

### 模块

- 模块名使用小写字母加下划线，模块的输入输出信号名也使用小写字母加下划线，模块的输入输出信号位宽尽量使用常量（比如`W_REGF`，`W_ADDR`，`W_DATA`）；
- 模块的源文件名与模块名相同，存放在`src`目录中，例如模块`stage_d`隶属于`datapath`，而`datapath`隶属于`mips`，那`stage_d.v`应当位于`src/mips/datapath/`目录下；
- 特别的，工具模块（比如多路选择器，寄存器等）统一存放在`src/utils/`目录下；
- 每个模块都必须拥有一个与之对应的文档，描述这个模块的输入输出信号定义，一些备注，当前存在的问题等，存放路径格式与源文件相同（但在`doc`目录下）；
- 如果一个模块比较复杂，那么可以单独为它写一个测试，测试用到的代码和其它文件存放路径格式与源文件相同（但在`sim`目录下）；
- 代码统一用四个空格（**不要用Tab！！！**）缩进，其余格式随意，但同一个模块的代码风格最好一致（参考[这里](https://verilogcodingstyle.readthedocs.io/en/latest/source/1BasicSyntax_cn.html#id12)，但不要用他的命名方式和缩进）。

### 分支

- 每个模块单独分配一个分支，名字为`dev-<模块名，但下划线变成中横线>`，例如模块`stage_d`使用分支`dev-stage-d`；
- 该模块的源文件、测试文件和文档都属于这个分支；
- 当模块的输入输出信号定义完成（但还没有实现）时，合并到主分支；
- 当模块的功能实现完成，并且通过单元测试（如果有的话）时，再次合并到主分支；
- 如果发现BUG，先在模块自己的分支内修改，测试通过之后，再合并到主分支。

### 语言

- Git的提交信息使用中文，描述清楚这次提交干了什么；
- 注释中英文随意，但请确保语法是对的并且。

## 整体架构

- `mips`：处理器
  - `alu`：运算器
  - `control`：控制器
  - `hazard`：冲突管理器
  - `register_file`：寄存器堆
  - `datapath`：数据通路
    - `stage_f`：取值阶段
    - `stage_d`：译码阶段
    - `stage_e`：执行阶段
    - `stage_w`：写回阶段

- `utils`：工具集，不是一个模块
  - `mux2`：二路选择器
  - `mux4`：四路选择器
- `includes`：头文件集，不是一个模块
  - `width.vh`：定义了一些常用位宽
  - `registers.vh`：定义了一些特殊寄存器号
  - `instr.vh`：定义了指令相关的常量