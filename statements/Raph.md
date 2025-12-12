# Raphael's Personal Statement

- Name: Raphael Sinai
- CID: 02585981
- Github Username: Raphsinai

## Summary

I worked as the verification engineer, debugging most of the errors and fixing what didn't behave as expected. I was in charge of the integration, when multiple people work on their own modules, the conflicts had to be resolved.


## top.sv for single cycle

Following the original diagram for the single cycle cpu and my team's implementation of each module, I created the [top.sv](https://github.com/vishalarun7/RISC-V-Team17/blob/main/rtl/top.sv) file.

After generating this file, I ran all of the tests and had to fix the problems that arose in each of them.

These include:
- Syntax errors and correct parameterisation.
- Fixing the functionality of ALU, making sure it is executing the correct function for each opcode
- Fixed the memory loading as it wasn't correctly loading the data for pdf test

Most of my work for single cycle was therefore debugging and ALU implementation.


### F1 Testing

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


## Debugging for pipeline

Ensuring that the pipelined CPU worked was much trickier than the single cycle CPU.

### Inital testing

To begin with, the required tests 1 3 and 4 were failing.
