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
    J _loop

finish:
    J finish
