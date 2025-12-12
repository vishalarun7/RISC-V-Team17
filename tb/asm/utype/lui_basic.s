.text
.globl main
# Test 1: LUI basic functionality
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    lui     t0, 0x12345         # t0 = 0x12345000
    li      t1, 0x12345000      # expected result
    beq     t0, t1, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
