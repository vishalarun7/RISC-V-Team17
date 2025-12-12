.text
.globl main
# Test 1: ANDI (and immediate)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    li      t0, 0xFFFF          # t0 = 0x0000FFFF
    andi    t1, t0, 0x7F0       # t1 = 0x0000FFFF & 0x7F0 = 0x07F0
    li      t2, 0x7F0           # expected result
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
    jal     zero, finish
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
