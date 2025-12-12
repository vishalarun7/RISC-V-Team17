.text
.globl main
# Test 1: BNE should branch when values are different
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 5         # t0 = 5
    addi    t1, zero, 3         # t1 = 3
    bne     t0, t1, test_pass   # should branch (5 != 3)
    addi    a0, a0, 100         # shouldn't execute (fail)
test_pass:
    addi    a0, a0, 1           # a0 = 1 (test passed)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
