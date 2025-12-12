.text
.globl main
# Test 2: BEQ should NOT branch when values are different
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 5         # t0 = 5
    addi    t1, zero, 3         # t1 = 3
    beq     t0, t1, test_fail   # should NOT branch (5 != 3)
    addi    a0, a0, 1           # a0 = 1 (test passed)
    beq     zero, zero, finish  # go to finish
test_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
