# Vishal Arun (CID:02636117)    

# Table of contents
- Single cycle
	- Control Unit + Fetch - Top
    - Sign Extension Unit 
    - Instruction Memory
    - Data Memory

- Pipelining
	- Fetch–Decode Pipeline
    - Decode–Execute Pipeline	
    - Execute–Memory Pipeline	
    - Memory–Writeback Pipeline	
    - Hazard Unit
	- Debugging 
- Further Improvements 
- Takeaways


# Single Cycle

## Control Unit

- I implemented logic for R-type, I-type, S-type, B-type, U-type, and J-type instructions, ensuring each instruction type could drive the ALU, memory, and register file appropriately.

- A key part of the code that simplified how I went about this module was the ALU_control task, which translates opcode and function bits into specific ALU operations dynamically. This allowed the same ALU to handle addition, subtraction, logical, and shift operations through a 3 bit signal. 

```bash
 task ALU_control(
      input   logic [6:0] op_code,
      input   logic [2:0] funct_3,
      input   logic       funct_7,
      output  logic [3:0] ALU_control
  );
      begin
          case (funct_3)
              3'd0: if (op_code == 7'b0010011) ALU_control = 4'b0000;
                    else   ALU_control = funct_7 ? 4'b0001 : 4'b0000; // add | addi (funct7 = 0) or sub (funct7 = 1)
              3'd1: ALU_control = 4'b0101; // sll | slli
              3'd2: ALU_control = 4'b1000; // slt | slti
              3'd3: ALU_control = 4'b1001; // sltu | sltiu
              3'd4: ALU_control = 4'b0100; // xor | xori
              3'd5: ALU_control = funct_7 ? 4'b0110 : 4'b0111; // srl | slri (funct7 = 0) or sra | srai (funct7 = 1)
              3'd6: ALU_control = 4'b0011; // or | ori
              3'd7: ALU_control = 4'b0010; // and | andi
              default: ALU_control = 4'b0000; // undefined
          endcase
      end
  endtask
```

- A nuance I failed to catch on until much later, was the implications of making PCSrc 2 bits. Though it worked perfectly for sequential instructions, jumps, and branches, by selecting between PC+4, PC+Imm and ALUResult through a 4-to-1 mux in the fetch stage, there were still several problems when this was pipelined. 
- Notice that the fetch stage runs ahead of execute, so the decision for PCSrc sometimes depends on ALU results (Zero, Negative) that haven’t been computed yet.
#### Snippet from Control Unit

```bash
  output logic [1:0]  PCSrc,     //pc mux sel line; 0 = pc+4 ; 1 = pc+imm (branch,jal); 2 = aluresult (jalr) ; 3 = pc (stall)
```

#### Snippet from Fetch - Top

```bash
    mux4 PCMux(
        .in0 (PCPlus4),
        .in1 (PCTarget),
        .in2 (ALUResult),
        .in3 (PC),
        .sel (PCSrc),
        .out (PCNext)
    );
```

## Sign Extension
- Implements sign-extension of immediate values for instruction types (I, S, B, U, J).
- Extracts relevant bits from the instruction and reformats them into 32-bit immediates suitable for ALU, branch, or memory operations.
- Controlled by the ImmSrc signal from the control unit to select the correct immediate type.
```bash
  case (ImmSrc)
  3'b000: ImmExt = {{20{instr[31]}}, instr[31:20]}; // I-type
  3'b001: ImmExt = {{20{instr[31]}}, {instr[31:25], instr[11:7]}}; // S-type
  3'b010: ImmExt = {{19{instr[31]}}, {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}}; // B-type
  3'b011: ImmExt = {{11{instr[31]}}, {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}}; // J-type
  3'b100: ImmExt = {instr[31:12], 12'b0}; // U-type
endcase
```


## Instruction Memory
- Stores program instructions and outputs a 32-bit instruction for a given address.
- Supports sequential instruction fetch for the processor
```bash
instr = {rom_array[addr+3], rom_array[addr+2], rom_array[addr+1], rom_array[addr]};
```


## Data Memory
- Implements read/write memory for load and store instructions.
- Supports word (lw/sw) and byte (lbu/sb) operations controlled by AddrMode.
- Reads/writes are byte-addressable and aligned for little-endian storage.
```bash
// Word-aligned read
RD = {ram_array[word_address+3], ram_array[word_address+2], ram_array[word_address+1], ram_array[word_address]};
// Word/byte write
if (MemWrite && AddrMode==0) ram_array[word_address +:4] <= RD2; 
else if (MemWrite) ram_array[aluresult] <= RD2[7:0];
```

# Pipelined

Pipelining enables multiple instructions to be in-flight simultaneously, improving throughput compared to the single-cycle design. The pipelined implementation splits the CPU into 5 main stages:
1. Fetch  
2. Decode  
3. Execute  
4. Memory
5. Writeback  

## Pipeline Registers

My pipelined CPU uses four pipeline registers, one between each stage—to hold intermediate values and control signals. These registers isolate stages, allowing multiple instructions to execute simultaneously without interfering with each other.

### Fetch-Decode Register

- Captures the fetched instruction and the current PC.

- Provides stable inputs to the decode stage even while the fetch stage moves on.

- Includes logic to flush on branch/jump and stall on hazards.

Purpose: Keeps instruction flow correct despite branch delays or hazards.

```bash
always_ff @(posedge clk) begin
    if (FlushD) begin
        instrD <= 32'b0;
        pcD    <= 32'b0;
    end 
    else if (!StallD) begin
        instrD <= instrF;
        pcD    <= pcF;
    end
end
```

- FlushD = 1: replace the instruction with a NOP — used for branch mispredicts or wrong-path instructions.
- StallD = 1: freeze the IF/ID register — keep the old values when handling hazards.
- Otherwise: load the next instruction normally from IF.
- Priority: Flush > Stall > Normal operation.

### Decode-Execute Register
- It stores all control and data signals generated during the Decode stage and forwards them to the Execute stage on the next clock cycle. The module also supports flushing: when FlushE (necessary for Cache) is asserted, all control signals entering the Execute stage are cleared to prevent incorrect instruction execution (e.g., during branch mispredictions or hazards), while data signals continue to pass through unchanged.
- Note: It is only the control signals that are stalled or flushed; the data signals are irrelevant. 


### Execute-Memory Register

The execute_memory module forms the pipeline register between the Execute (E) and Memory (M) stages. It captures ALU results, write-data, and control signals generated in the Execute stage and forwards them to the Memory stage on the next clock edge. This ensures stable and synchronized data flow through the pipeline while preserving instruction ordering.
```bash
always_ff @(posedge clk) begin
    ALUResultM <= ALUResultE;
    WriteDataM <= WriteDataE;
    PCPlus4M   <= PCPlus4E;

    MemWriteM  <= MemWriteE;
    RegWriteM  <= RegWriteE;
    ResultSrcM <= ResultSrcE;
    AddrModeM  <= AddrModeE;
    RdM        <= RdE;
end
```

### Memory-Writebacks Register

The memory_writeback module passes values from the Memory (M) stage into the Writeback (W) stage. It stores control signals (such as RegWrite) and results from either memory or the ALU, along with the destination register. On every clock cycle, these values are latched and made available to the final stage, ensuring correct register file updates.


## Hazard Unit

The hazard_unit module handles all data and control hazards in the pipelined processor. It ensures correct execution by detecting situations where an instruction depends on a value that has not yet been written back, and by forwarding or stalling the pipeline when needed.

### Data Hazards

A data hazard occurs when an instruction tries to read a register whose value is still being produced by an earlier instruction.
To resolve this, the hazard unit implements two mechanisms:

- Forwarding (bypassing):
If the Execute-stage source registers (Rs1E or Rs2E) match a destination register in a later stage (MEM or WB), the corresponding value is forwarded directly to the ALU.

    - 10 selects forwarded data from MEM

    -  01 selects forwarded data from WB

    - 00 uses the normal register file output

- Load-use stall:
A special case occurs when the instruction in the Execute stage is a load (ResultSrcE == 2'b01). Since the loaded data is not available until the Memory stage, forwarding cannot satisfy the dependency.
If the Decode-stage instruction reads the same register as the load’s destination (RdE), the pipeline must stall for one cycle.
This is expressed as:
```bash
if (ResultSrcE == 2'b01 && ((Rs1D == RdE) || (Rs2D == RdE)))
    lwStall = 1;
```

### Control Hazards

Control Hazards

A control hazard occurs when the processor has not yet determined the next PC — for example, during branches.
If the instruction in Decode depends on the result of an instruction still in Execute or Memory (such as a load feeding a branch comparison), the branch cannot yet make a correct decision. The hazard unit detects these cases and stalls the pipeline until the needed value is produced.

Additionally, when a branch is taken (PCSrcE = 1), the Decode and Execute stages are flushed.
Flushing means the instruction is replaced with a NOP — it flows down the pipeline but does nothing.

- Stalling and Flushing Logic
    - StallF / StallD pause the Fetch and Decode stages when a hazard is detected.
    - FlushE clears the Execute-stage pipeline register when stalling or during a taken branch.
    - FlushD clears the Decode-stage instruction only for taken branches.
    - This ensures that invalid or partially decoded instructions are prevented from executing.
```bash
assign StallF = lwStall | branchStall;
assign StallD = lwStall | branchStall;
assign FlushE = lwStall | branchStall | PCSrcE;
assign FlushD = PCSrcE;
```

## Testing
![All 5 Tests passed](RISC-V-Team17/images/Screenshot 2025-12-12 at 6.18.42 PM.png)

During testing, the most significant issue encountered was related to the LUI (Load Upper Immediate) instruction. In RISC-V, lui loads a 20-bit immediate into the upper bits of a register, and it is also used internally when assembling large constants — for example, the li pseudo-instruction often expands into a combination of LUI + ADDI.

Initially, the control logic incorrectly assigned:
```bash
ResultSrc = 2'b11   // assuming a 4-input mux for writeback
```


This caused certain li instructions to fail because the LUI value was not being written back correctly. The proper behavior for lui is simply to write the extended immediate directly to the register file, so the correct control configuration is:
```bash
// U-type (lui)
7'b0110111: begin 
    RegWrite   = 1'b1;
    ImmSrc     = 3'b100;
    MemWrite   = 1'b0;
    ResultSrc  = 2'b00; // FIXED: write immediate result directly
    Jump       = 1'b0;
    Branch     = 1'b0;
    ALUSrc     = 1'b1;
    ALUControl = 4'b0000;
end
```
Identifying and resolving this bug took several days of debugging.

# Takeaways
This project was one of the most challenging and rewarding technical experiences I have worked on. Building a pipelined RISC-V processor from scratch required me to develop a much deeper understanding of CPU architecture, including instruction formats, control-path design, ALU operations, forwarding logic, hazard detection, and how each part of the pipeline interacts with the next. I especially gained confidence in debugging complex timing and control issues, such as the 2 days spent on the LUI/LI bug. These experiences taught me how subtle design decisions can propagate through the entire pipeline and how important systematic debugging is in hardware design.

Beyond the technical side, I also learned a lot about communication and teamwork. Although our group was larger, only three of us were consistently and actively contributing to the project. This made the workload heavier for those involved, but it also taught me how to coordinate tasks more effectively, share progress clearly, and maintain a collaborative mindset even when participation levels varied. I learned how important it is to communicate early, divide responsibilities realistically, and support each other through the more difficult debugging stages—all of which ultimately made the project stronger.

Overall, this project substantially broadened my understanding of RISC-V, pipelines, and computer architecture as a whole. It has also made me excited to take the next step: building a compiler that targets our processor design. If we had more time, I would have loved to explore superscalar or dual-issue extensions, as the idea of scaling this design into a more parallel, higher-performance architecture is something that now feels within reach.


