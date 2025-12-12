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
|                  | **System Integration + Debugging**|      |    *  |      |   X   |
| **Cache**        | **Memory (Refactor)**             |        |    X    |      |      |
|                  | **Direct-Mapped Cache**           |        |     X   |      |      |
|                  | **Two-Way Set Associative Cache** |        |      X  |      |      |
|                  | **System Integration + Debugging** |        |      X  |      |   *   |

| **Verification** | **F1 Testing**                    |        |        |      |  X   |
|                  | **PDF Testing**                   |        |        |      |  X   |
|                  | **System Testing & Debugging**    |        |        |      |  X   |
|                  | **F1 Assembly.s**                 |        |        |      |  X   |
| **Other**        | **Vbuddy**                        |        |        |      |  X   |


**X = Lead Contributor**  
**\* = Partial Contributor**

## Single Cycle - 
This single cycle implementation covers the basic requirements for most CPU operations, this implements the following instructions: R-type, I-type (immediate), lbu, sb, beq, bne, jal, jalr, lui.


## File Structure

```
.
├── rtl
│   ├── adder.sv
│   ├── decode
│   │   ├── control.sv
│   │   ├── reg_file.sv
│   │   └── signextend.sv
│   ├── execute
│   │   ├── alu.sv
│   ├── fetch
│   │   ├── fetch_top.sv
│   │   ├── instr_mem.sv
│   │   └── pc_register.sv
│   ├── memory
│   │   ├── datamem.sv
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
    ├── assemble.sh
    ├── vbuddy.cfg
    ├── verification.md
    ├── tests
    │   ├── cpu_testbench.h
    │   └── verify.cpp

```

The processor development is done in the register transfer level (`rtl`) folder and the testing is performed in the test bench folder (`tb`).
The test bench folder contains:
- Assembly files (1 to 5 provided and f1_fsm) - in later versions
- `assemble.sh` - translating RISCV assembly to machine code
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

-- 

## Pipelined Processer
The pipelined implementation supports the RV32I instruction set, dividing the processor into four main stages: fetch, decode, execute, and memory. The fundamental principle of pipelining is parallel instruction execution, where different stages of multiple instructions are processed simultaneously. This increases instruction throughput and, in real-world CPUs, enables higher clock speeds. Together, these improvements result in faster program execution compared to the single-cycle variant.

## File Structure

```
.
├── rtl
│   ├── adder.sv
│   ├── decode
│   │   ├── control.sv
│   │   ├── reg_file.sv
│   │   └── signextend.sv
│   ├── execute
│   │   ├── alu.sv
│   ├── fetch
│   │   ├── fetch_top.sv
│   │   ├── instr_mem.sv
│   │   └── pc_register.sv
│   ├── memory
│   │   ├── datamem.sv
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
    ├── assemble.sh
    ├── vbuddy.cfg
    ├── verification.md
    ├── tests
    │   ├── cpu_testbench.h
    │   └── verify.cpp

```

## Implementation

Transitioning from single-cycle to pipelined introduces various significant changes to the design structure. There are many new modules and concepts in the pipelined version.

# 1. Pipeline Registers
- Pipeline registers separate each stage of the pipeline.
- They hold all relevant instruction data, including control signals, for processing in the next stage.
- Updated on every negative clock edge with new subsequent instruction information.

# 2. New Control Unit Signals
- **Branch Flag:**
  - Carried to the execute stage for branch evaluation.
- **Jump Flag:**
  - Controls JAL and JALR instructions in the execute stage.

# 3. Branch Logic Module
- Branch evaluation is deferred to the execute stage to utilize ALU flags, introducing a delay compared to single-cycle processing.
- Determines branch conditions using:
  1. ALU flags
  2. Branch signals
  3. Jump signals

# 4. Hazard Detection Unit
- Resolves data hazards by forwarding data from the memory or write-back stages to the execute stage.
- Uses new wires from the decode stage carrying operand addresses to compare against destination registers in later stages.
- Includes forwarding multiplexers to select the appropriate forwarding data source.

# 5. Flushing Mechanism
- Clears the decode pipeline register to remove incorrect instructions if a branch is taken.
- Activates when the branch logic module determines a jump is executing.


## Testing

--

## Data Memory Cache

Cache memory in RISC-V employs direct-mapped, set-associative, or fully associative mapping to determine data placement, in this implementation we utilise 2-way set associative cache. Tags and valid bits identify cached data, while replacement policies like LRU handle evictions. Write policies such as write-through and write-back manage consistency between cache and memory. These techniques ensure efficient data access, reducing latency and leveraging locality principles for optimised performance.


## File Structure

```
.
├── rtl
│   ├── adder.sv
│   ├── decode
│   │   ├── control.sv
│   │   ├── reg_file.sv
│   │   └── signextend.sv
│   ├── execute
│   │   ├── alu.sv
│   ├── fetch
│   │   ├── fetch_top.sv
│   │   ├── instr_mem.sv
│   │   └── pc_register.sv
│   ├── memory
│   │   ├── datamem.sv
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
    ├── assemble.sh
    ├── vbuddy.cfg
    ├── verification.md
    ├── tests
    │   ├── cpu_testbench.h
    │   └── verify.cpp

```

## Implementation




## Testing

--
