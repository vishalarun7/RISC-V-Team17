# Raphael's Personal Statement

- Name: Raphael Sinai
- CID: 02585981
- Github Username: Raphsinai

## Summary

I worked as the verification engineer, debugging most of the errors and fixing what didn't behave as expected. I was in charge of the integration, when multiple people work on their own modules, the conflicts had to be resolved.


## top.sv for single cycle

> The following can be found on the main branch

Following the original diagram for the single cycle cpu and my team's implementation of each module, I created the [top.sv](https://github.com/vishalarun7/RISC-V-Team17/blob/main/rtl/top.sv) file.

After generating this file, I ran all of the tests and had to fix the problems that arose in each of them.

These include:
- Syntax errors and correct parameterisation.
- Fixing the functionality of ALU, making sure it is executing the correct function for each opcode
- Fixed the memory loading as it wasn't correctly loading the data for pdf test

Most of my work for single cycle was therefore debugging and ALU implementation.


### F1 Testing

VIDEO: [LINK TO SINGLE CYCLE F1 VIDEO](https://github.com/vishalarun7/RISC-V-Team17/blob/main/tb/videos/singlecycle.mp4)

I was in charge of implementing the F1 sequence.

f1.s:
```asm
.text
.globl main

main:
    LI a0, 0
    LI a1, 0
    LI s1, 8

_loop:
    BGE a1, s1, finish
    JAL t1, incr
    J _loop

incr:
    ADDI a1, a1, 1
    SLLI a2, a0, 1
    ADDI a0, a2, 1
    JALR x0, 0(t1)  

finish:
    J finish
```

in the `main` section, the registers are initialised:
- a0 is set to 0
- a1 is set to 0
- s1 is set to 8

We then enter the loop. The first thing that happens is a check to see if the output is at or greater than out final state. This is achieved by checking the register a1 which tells us how many times we've shifted the output, this is when it is 8 as that's the amount of lights.

If we haven't reached the end of the program, we increment the lights shown, this is done by shifting the current value left by 1 and adding one. For example:

Start values:
- a0 = b11
- a1 = 2

In incr after each instruction:
- `addi`: a1 = 3
- `slli`: a2 = b110
- `addi`: a0 = b111

This means that operations are done in the registers not outputted and only the final stage is written to `a0` the output register.

After this, the code jumps back to the _loop section where this sequence is repeated until all 8 bits are 1.

When all bits are 8, the program infinitely loops until terminated by verilator.

#### Vbuddy implementation

To view the program, `verify.cpp` had to change to connect to the Vbuddy.

```cpp
TEST_F(CpuTestbench, F1)
{
    setupTest("f1");
    initSimulation();
    if (vbdOpen() != 1)
        FAIL();
    vbdHeader("F1 RISC-V");
    vbdSetMode(1);
    vbdBar(0);

    int cyc;
    int tick;
    
    for (cyc = 0; cyc < CYCLES / 100; cyc++) {
        runSimulation(1);

        vbdCycle(cyc);
        vbdBar(top_->a0 & 0xFF);
        vbdHex(3,(int(top_->a0)>>8)&0xF);
        vbdHex(2,(int(top_->a0)>>4)&0xF);
        vbdHex(1,int(top_->a0)&0xF);

        if (Verilated::gotFinish()) {
            vbdClose();
            EXPECT_EQ(top_->a0, 255);
        }
    }

    vbdClose();
}
```

This code uses the functions provided in `cpu_testbench.h` and `vbuddy.cpp` to display `a0` on the Vbuddy screen and LED bar. The test is setup using `setupTest("f1")` and initialised with `initSimulation()`, we then focus on the Vbuddy initialising what we want to see. Instead of running for `CYCLES` we have a loop where we run one cycle and update the Vbuddy's outputs with `top_->a0`. If the simulation ends, we tell gtest to expect `a0` to be `0xFF`.

## Debugging for pipeline

> The following can be found on the pipelined branch

Ensuring that the pipelined CPU worked was much trickier than the single cycle CPU. For each of these changes, an extensive use of gtkwave was very helpful to visualise which instruction was failing.

### Inital testing

To begin with, the required tests 1 3 and 4 were failing.

The first problem was that J-type and U-type instructions were reversed, simple fix just had to change

```diff
- RegWrite = 1'b1; ImmSrc = 3'b100; MemWrite = 1'b0; ResultSrc = 2'b10; PCSrc = 2'b01;
+ RegWrite = 1'b1; ImmSrc = 3'b011; MemWrite = 1'b0; ResultSrc = 2'b10; PCSrc = 2'b01;
```
for J-type (JAL test)

and

```diff
- RegWrite = 1'b1; ImmSrc = 3'b011; MemWrite = 1'b0; ResultSrc = 2'b11; PCSrc = 2'b00;
+ RegWrite = 1'b1; ImmSrc = 3'b100; MemWrite = 1'b0; ResultSrc = 2'b11; PCSrc = 2'b00;
```

for U-type (LUI test)

In a similar fashion, the result src was incorrect for these functions, it wasn't seperating alu result immex and pcplus4 correctly.

```sv
2'b10: Result = PCPlus4;        // PC+4 (for JAL/JALR)
2'b11: Result = ImmExt;         // Immediate (for LUI)
```

### JAL broken

In the execute stage, the `PCTarget` was always being set to `PC + ImmExt' which is incorrect as for these instructions, the target needs to be the result of the ALU.
So the following change was made:

```diff
- assign PCTargetE = PCE + ImmExtE;
+ assign PCTargetE = ALUSrcE ? ALUResultE : (PCE + ImmExtE);
```

This mux allows us to use the ALU result instead of `PC + ImmExt` when required.

Side note: this commit also adds this line so the output is correct
```diff
+ assign a0 = a0_regfile;
```

### Major fix: BNE not working

This fix required much more thinking although the solution was much simpler than expected.

Initially, the `BranchTaken` logic was using the `Zero` flag which is incorrect. This required the addition of a combination logic block based on funct3  as so:

```sv
    logic BranchCondE;
    always_comb begin
        case (funct3E)
            3'b000: BranchCondE = ZeroE;              // beq: branch if equal
            3'b001: BranchCondE = ~ZeroE;             // bne: branch if not equal
            3'b100: BranchCondE = ALUResultE[0];      // blt: branch if less than (signed)
            3'b101: BranchCondE = ~ALUResultE[0];     // bge: branch if greater or equal (signed)
            3'b110: BranchCondE = ALUResultE[0];      // bltu: branch if less than (unsigned)
            3'b111: BranchCondE = ~ALUResultE[0];     // bgeu: branch if greater or equal (unsigned)
            default: BranchCondE = 1'b0;
        endcase
    end
```

This change was implemented in [top.sv](https://github.com/vishalarun7/RISC-V-Team17/blob/pipelined/rtl/top.sv) which required me to route all the necessary wires through [hazard_unit.sv](https://github.com/vishalarun7/RISC-V-Team17/blob/pipelined/rtl/hazard_unit.sv), [control.sv](https://github.com/vishalarun7/RISC-V-Team17/blob/pipelined/rtl/decode/control.sv) and [decode_execute.sv](https://github.com/vishalarun7/RISC-V-Team17/blob/pipelined/rtl/pipelines/decode_execute.sv)

### Internal forwarding

If the execute stage is writing to a register that the fetch stage requires, there is a delay that breaks it so this piece of logic is required:

```sv
assign RD1 = (AD1 == 0) ? 0 : 
                (WE3 && (AD1 == AD3)) ? WD3 : 
                register[AD1];
                
assign RD2 = (AD2 == 0) ? 0 : 
                (WE3 && (AD2 == AD3)) ? WD3 : 
                register[AD2];
```

### F1 testing in pipeline

VIDEO: [LINK TO PIPELINED F1 VIDEO](https://github.com/vishalarun7/RISC-V-Team17/blob/main/tb/videos/pipeline.mp4)

When running the F1 test, it was failing after setting the register s1 to 8. I found this to be due to `BGE a1, s1, finish` incorrectly jumping the first time it is called.

I decided that I would fix all the branching functions.

The following block of logic had to be added to the ALU

```sv
7'b1100011: begin
    RegWrite = 1'b0; ImmSrc = 3'b010; ALUSrc = 1'b0; MemWrite = 1'b0; Branch = 1'b1; Jump = 1'b0;
    // Set ALU operation based on branch type
    case (funct3)
        3'b100: ALUControl = 4'b1000;  // blt: use SLT (signed less than)
        3'b101: ALUControl = 4'b1000;  // bge: use SLT (signed less than)
        3'b110: ALUControl = 4'b1001;  // bltu: use SLTU (unsigned less than)
        3'b111: ALUControl = 4'b1001;  // bgeu: use SLTU (unsigned less than)
        default: ALUControl = 4'b0001; // beq/bne: use SUB
    endcase
end
```

To make sure that all of the branches work I added the following tests to keep track of why exactly each instruction fails if it does:
- test_beq.s
- test_bge.s
- test_bgeu.s
- test_blt.s
- test_bltu.s
- test_bne.s

### Final mass testing

Now that crucial tests are working as intended