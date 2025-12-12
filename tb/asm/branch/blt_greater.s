.text
.globl main
# Test 2: BLT should NOT branch when first >= second
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 8         # t0 = 8
    addi    t1, zero, 5         # t1 = 5
    blt     t0, t1, test_fail   # should NOT branch (8 >= 5)
    addi    a0, a0, 1           # a0 = 1 (test passed)
    beq     zero, zero, finish  # go to finish
test_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
