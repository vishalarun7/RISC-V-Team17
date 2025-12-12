.text
.globl main
# Test 1: Basic SW and LW
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    li      s0, 0x00010000      # base address for data memory
    
    li      t0, 0xDEADBEEF      # t0 = test value
    sw      t0, 0(s0)           # store at address 0x00010000
    lw      t1, 0(s0)           # load from same address
    beq     t0, t1, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
