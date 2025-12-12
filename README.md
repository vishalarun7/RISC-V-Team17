# RISC-V-Team17

RISC-V 32I CPU designed as part of the Instruction Architectures and Compilers class.

---
## Personal Statements

- [Vishal](statements/Vishal.md)
- [Raph](statements/Raph.md)
- [Nikhil](statements/Nikhil.word)
- [Emir]()

---
## Table of Contents

- [Quick Start](#quick-start)
- [Single Cycle](#single-cycle)
- [Pipelined](#pipelined)
- [Cache](#cache)

---

## Quick Start

We completed the Single-Cycle CPU and two stretch goals (Pipelined CPU and 2 way Set Associative Cache with Pipeline).  These are organised into the following branches:

| Branch    | Description                                   |
|----------|-----------------------------------------------|
| `main`   | Single-Cycle Implementation                   |
| `pipelined` | Pipelined Implementation   |
| `cache`  | Cache + Pipelined Implementation           |

To access each version:

```bash
git checkout <branch-name>
```

### Testbench Usage

> IMPORTANT: Run all testbench scripts from the `/tb` directory.  
> Testbenches are written assuming absolute paths referenced from `/tb`.

#### GTest Testing

To run the provided tests in the selected branch:
```bash
cd ./tb
doit.sh tests/verify.cpp
```


### Contributions

Our contributions to the assignement are summarized in the table below. 
- Legend:  
  - **X** = Lead contributor  
  - **\*** = Partial contributor 

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
|                  | **Hazard Unit**                   |   X    |        |      |      |
|                  | **System Integration + Debugging**|    *    |       |      |  X   |
| **Cache**        | **Memory (Refactor)**             |        |   X    |      |      |
|                  | **Direct-Mapped Cache**           |        |   X    |      |      |
|                  | **Two-Way Set Associative Cache** |        |   X    |      |      |
|                  | **System Integration + Debugging**|        |   X    |      |  *   |
| **Verification** | **F1 Testing**                    |        |        |      |  X   |
|                  | **PDF Testing**                   |        |        |      |  X   |
|                  | **System Testing & Debugging**    |        |        |      |  X   |
|                  | **F1 Assembly.s**                 |        |        |      |  X   |
| **Other**        | **Vbuddy**                        |        |        |      |  X   |

 


---

----
## Single Cycle

### Overview

The single-cycle implementation supports the core RV32I subset, including:  
R-type, I-type (immediate), `lbu`, `sb`, `beq`, `bne`, `jal`, `jalr`, and `lui`.

![Single Cycle MIPS Processor](images/Single.png)

### File Structure


The processor implementation lives in `rtl`, and all testing infrastructure lives in `tb`.  
The `tb` folder contains:

- Assembly programs (`1`–`5` and `f1_fsm` variants)  
- `assemble.sh` – assembles RISC‑V source into machine code  
- VBuddy-related configs/tests (plus generated artefacts such as `*.vcd`)

> Note: only the single-cycle version shows the full `tb` contents for brevity.

### Instruction Support

| Type     | Instructions                                                    |
|----------|-----------------------------------------------------------------|
| R        | `add`, `sub`, `xor`, `or`, `and`, `sll`, `srl`, `sra`, `slt`, `sltu` |
| I (ALU)  | `addi`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`, `slti`, `sltiu` |
| I (load) | `lbu`, `lw`                                                     |
| I (jump) | `jalr`                                                          |
| S        | `sb`, `sw`                                                      |
| B        | `beq`, `bne`                                                    |
| U        | `lui`                                                           |
| J        | `jal`                                                           |

### Testing

#### Core Tests

For the provided assembly tests:

- `1_addi_bne`  
- `2_li_add`  
- `3_lbu_sb`  
- `4_jal_ret`  
- `5_pdf`  

The waveforms and behaviour can be inspected via the generated traces and VBuddy outputs.

Single-cycle verification image:  
![5 tests passed](images/pipelinetest.png)

#### F1

- Video: `images/vbuddy_tests/F1_FSM.mp4`

#### PDF: Gaussian

- Video: `images/vbuddy_tests/PDF-Gaussian.mp4`

#### PDF: Noisy

- Video: `images/vbuddy_tests/PDF-Noisy.mp4`

#### PDF: Triangle

- Video: `images/vbuddy_tests/PDF-Triangle.mp4`

---

## Pipelined

### Overview

![Diagram](images/harris.png)

The pipelined implementation supports the full RV32I instruction set.  
The CPU is split into four main stages:

1. Fetch  
2. Decode  
3. Execute  
4. Memory / Writeback  

Pipelining enables multiple instructions to be in-flight simultaneously, improving throughput compared to the single-cycle design.

### File Structure

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


### Implementation Details

#### 1. Pipeline Registers

- Separate each pipeline stage (F–D, D–E, E–M, M–W).  
- Latch instruction data and derived control signals for the next stage.  
- Typically updated on the active clock edge (e.g. negative edge in this design).

#### 2. Extended Control Signals

- **Branch flag**: carried into the execute stage for branch condition evaluation.  
- **Jump flag**: controls `jal` and `jalr` behaviour in the execute stage.

#### 3. Branch Logic

- Branch decision moved to the execute stage to reuse ALU comparison results.  
- Consumes:
  - ALU flags  
  - Branch control signals  
  - Jump control signals  
- Introduces a control hazard penalty on taken branches.

#### 4. Hazard Detection / Forwarding

- Detects data hazards by comparing source register addresses from decode with destination registers in later stages.  
- Forwards results from memory or writeback back to execute through multiplexers.  
- Minimises stalls while preserving correctness.

#### 5. Flushing

- On a taken branch or jump, clears the decode pipeline register.  
- Prevents wrong-path instructions from committing.

### Testing

Testing follows the same `tb` infrastructure and `doit.sh` flow as in the single-cycle design, with additional checks for correctness under hazards and branches.

---

## Cache
![Diagram](images/cache.png)

### Overview

The cached implementation introduces a data memory hierarchy on top of the single-cycle core.  
It uses a two-way set-associative, write-back cache to reduce effective memory latency by exploiting spatial and temporal locality.

### Design Notes

- Organisation: 2-way set-associative data cache.  
- Each line stores:
  - Tag  
  - Valid bit  
  - Dirty bit (for write-back)  
- Replacement: LRU-based policy between the two ways.  
- Write policy: write-back with write-allocate on misses.

### File Structure

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

Pipeline: 5 stages – IF, ID, EX, MEM, WB

### Stage Integration

- IF: Access instruction cache.
  -  Hit → fetch instruction.
  -  Miss → stall until memory fetch.

- EX: Compute memory addresses.

- MEM: Access data cache:

  - Load: Hit → read data, Miss → fetch block from memory, update cache, then continue.

  - Store: Hit → write to cache (and memory if write-through), Miss → write-allocate or write around.

- WB: Write data to register after MEM stage.

- Cache Miss Handling

  - Stall IF, ID, EX stages while MEM fetches from memory.

  - Resume pipeline once block arrives.


## Testing


