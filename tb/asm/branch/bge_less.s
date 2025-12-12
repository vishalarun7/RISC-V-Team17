.text
.globl main
# Test 3: BGE should NOT branch when first < second
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 3         # t0 = 3
    addi    t1, zero, 10        # t1 = 10
    bge     t0, t1, test_fail   # should NOT branch (3 < 10)
    addi    a0, a0, 1           # a0 = 1 (test passed)
    beq     zero, zero, finish  # go to finish
test_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
