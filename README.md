# RISC-V-Team17
RISC-V 32I CPU designed as part of the Instruction Architectures and Compilers class.

# Table of contents:

- [Quick Start](#quick-start)
- [Single Cycle CPU Implementation](#single-cycle)
- [Pipelined CPU Implementation](#pipelined-risc-v-cpu)
- [Cached Implementation](#data-memory-cache)

# Quick Start

We completed the Single-Cycle and 2 of the stretch goals (Pipelined, Two-Way Set Associative Write-Back Cache). These can be found it :
| Branch | Description |
| ------ | ----------- |
|`main` | Single-Cycle Implementation |
|`pipelined` | Pipelined (+ Full RV32I Implementation) Implementation |
|`cache` | Cache + Single-Cycle Implementation |

<br>

To access each version,
```bash
git checkout <branch-name>
```

### **IMPORTANT:** Please run all testbench scripts while in `/tb`. For simplicity, testbenches were written with absolute path referenced from `/tb`.

#### Quick Start - GTest Testing

To run the provided tests within the target branch,
```bash
 cd ./tb
doit.sh tests/verify.cpp
```


## Contributions

| Category         | Module                            | Vishal | Nikhil | Emir | Raph |
|------------------|-----------------------------------|:------:|:------:|:----:|:----:|
| **Single Cycle** | **ALU**                           |        |   X    |      |      |
|                  | **PC Register**                   |   *    |   *    |  X   |      |
|                  | **Instruction Memory**            |   X    |        |      |      |
|                  | **Data Memory**                   |   X    |        |      |      |
|                  | **Control Unit**                  |   X    |        |      |      |
|                  | **Register File**                 |        |   X    |      |      |
|                  | **Sign Extend**                   |   X    |        |      |      |
|                  | **Top (System Integration)**      |        |   *    |      |  X   |
| **Pipeline**     | **Fetch–Decode Pipeline**         |   X    |        |      |      |
|                  | **Decode–Execute Pipeline**       |   X    |        |      |      |
|                  | **Execute–Memory Pipeline**       |   X    |        |      |      |
|                  | **Memory–Writeback Pipeline**     |   X    |        |      |      |
|                  | **Hazard Unit**                   |   X   |      |      |      |
|                  | **System Integration + Debugging**|      |      |      |   X   |
| **Cache**        | **Memory (Refactor)**             |        |    X    |      |      |
|                  | **Direct-Mapped Cache**           |        |     X   |      |      |
|                  | **Two-Way Set Associative Cache** |        |      X  |      |      |
| **Verification** | **F1 Testing**                    |        |        |      |  X   |
|                  | **PDF Testing**                   |        |        |      |  X   |
|                  | **System Testing & Debugging**    |        |        |      |  X   |
|                  | **F1 Assembly.s**                 |        |        |      |  X   |
| **Other**        | **Vbuddy**                        |        |        |      |  X   |


**X = Lead Contributor**  
**\* = Partial Contributor**

Single Cycle - 
This single cycle implementation covers the basic requirements for most CPU operations, this implements the following instructions: R-type, I-type (immediate), lbu, sb, beq, bne, jal, jalr, lui.

## File Structure

```
.
├── rtl
│   ├── adder.sv
│   ├── decode
│   │   ├── control.sv
│   │   ├── decode_top.sv
│   │   ├── reg_file.sv
│   │   └── signextend.sv
│   ├── execute
│   │   ├── alu.sv
│   │   └── execute_top.sv
│   ├── fetch
│   │   ├── fetch_top.sv
│   │   ├── instr_mem.sv
│   │   └── pc_register.sv
│   ├── memory
│   │   ├── datamem.sv
│   │   └── memory_top.sv
│   ├── mux.sv
│   ├── mux_4x2.sv
│   └── top.sv
└── tb
    ├── asm
    │   ├── 1_addi_bne.s
    │   ├── 2_li_add.s
    │   ├── 3_lbu_sb.s
    │   ├── 4_jal_ret.s
    │   ├── 5_pdf.s
    │   ├── f1_fsm.s
    │   └── f1_fsm_simplified.s
    ├── assemble.sh
    ├── bash
    │   ├── control_test.sh
    │   ├── decode_top_test.sh
    │   ├── execute_test.sh
    │   ├── fetch_test.sh
    │   ├── memory_test.sh
    │   ├── reg_file_test.sh
    │   └── sign_extend_test.sh
    ├── doit.sh
    ├── f1_test.sh
    ├── our_tests
    │   ├── control_test_tb.cpp
    │   ├── datamem_tb.cpp
    │   ├── decode_top_test_tb.cpp
    │   ├── execute_tb.cpp
    │   ├── fetch_tb.cpp
    │   ├── memory_tb.cpp
    │   ├── reg_file_test_tb.cpp
    │   └── signextend_test_tb.cpp
    ├── pdf_test
    ├── pdf_test.sh
    ├── reference
    ├── test_out
    │   ├── 1_addi_bne
    │   ├── 2_li_add
    │   ├── 3_lbu_sb
    │   ├── 4_jal_ret
    │   ├── 5_pdf
    │   └── obj_dir
    ├── tests
    │   ├── cpu_testbench.h
    │   └── verify.cpp
    ├── two_way_cache_top.vcd
    ├── vbuddy.cfg
    ├── vbuddy_test
    │   ├── f1_fsm_tb.cpp
    │   ├── pdf_tb.cpp
    │   └── vbuddy.cpp
    └── verification.md
```

The processor development is done in the register transfer level (`rtl`) folder and the testing is performed in the test bench folder (`tb`).
The test bench folder contains:
- Assembly files (1 to 5 provided and f1_fsm) - in later versions
- `assemble.sh` - translating RISCV assembly to machine code
- `bash` and `out_tests` - independently created testing cases for individual components
- `vbuddy_test` - Tests creating to verify RISCV performance with VBuddy (provided)
Other files are either a result of these files (testing outputs e.g. `*.vcd`) or were provided.

Note: only for this version, is the `tb` folder shown, this contains the tests and shows all other execution files

## Implementation
Instructions implemented:

| Type     | Instruction                                                    |
| -------- | -------------------------------------------------------------- |
| R        | `add` `sub` `xor` `or` `and` `sll` `srl` `sra` `slt` `sltu`    |
| I (ALU)  | `addi` `xori` `ori` `andi` `slli` `srli` `srai` `slti` `sltiu` |
| I (load) | `lbu` `lw`                                                     |
| I (jump) | `jalr`                                                         |
| S        | `sb` `sw`                                                      |
| B        | `beq` `bne`                                                    |
| U        | `lui`                                                          |
| J        | `jal`                                                          |

## Testing
### Test cases
##### Note: if any of the videos fail to load, please find the videos in `./images/vbuddy_tests/`

For the tests provided (`1_addi_bne` `2_li_add` `3_lbu_sb` `4_jal_ret` `5_pdf`):

![Single cycle testing](/images/single-cycle-tests.png)

### F1
![Video for F1 lights](images/vbuddy_tests/F1.gif)

[Link to Video](images/vbuddy_tests/F1_FSM.mp4)

### PDF: Gaussian
![Video for PDF: Gaussian Test](images/vbuddy_tests/PDF-Gaussian.gif)

[Link to Video (Higher quality)](images/vbuddy_tests/PDF-Gaussian.mp4)

### PDF: Noisy
![Video for PDF: Noisy test](images/vbuddy_tests/PDF-Noisy.gif)

[Link to Video (Higher Quality)](images/vbuddy_tests/PDF-Noisy.mp4)

### PDF: Triangle
![Video for PDF: Triangle test](images/vbuddy_tests/PDF-Triangle.gif)

[Link to Video (Higher Quality)](/images/vbuddy_tests/PDF-Triangle.mp4)
