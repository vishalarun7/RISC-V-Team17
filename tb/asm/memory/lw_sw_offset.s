.text
.globl main
# Test 2: SW and LW with positive offset
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    li      s0, 0x00010000      # base address for data memory
    
    li      t0, 0x12345678      # t0 = test value
    sw      t0, 4(s0)           # store at address 0x00010004
    lw      t1, 4(s0)           # load from same address
    beq     t0, t1, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
