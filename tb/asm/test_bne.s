.text
.globl main
# Test BNE (Branch if Not Equal) instruction
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    # Test 1: BNE should branch when values are different
    addi    t0, zero, 5         # t0 = 5
    addi    t1, zero, 3         # t1 = 3
    bne     t0, t1, test1_pass  # should branch (5 != 3)
    addi    a0, a0, 100         # shouldn't execute (fail)
test1_pass:
    addi    a0, a0, 1           # a0 = 1 (test 1 passed)
    
    # Test 2: BNE should NOT branch when values are equal
    addi    t0, zero, 7         # t0 = 7
    addi    t1, zero, 7         # t1 = 7
    bne     t0, t1, test2_fail  # should NOT branch (7 == 7)
    addi    a0, a0, 1           # a0 = 2 (test 2 passed)
    beq     zero, zero, test3   # continue to test 3
test2_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
    # Test 3: BNE with zero
test3:
    addi    t0, zero, 5         # t0 = 5
    bne     t0, zero, test3_pass # should branch (5 != 0)
    addi    a0, a0, 100         # shouldn't execute (fail)
test3_pass:
    addi    a0, a0, 1           # a0 = 3 (test 3 passed)
    
    # Test 4: BNE with negative and positive
    addi    t0, zero, -5        # t0 = -5
    addi    t1, zero, 5         # t1 = 5
    bne     t0, t1, test4_pass  # should branch (-5 != 5)
    addi    a0, a0, 100         # shouldn't execute (fail)
test4_pass:
    addi    a0, a0, 1           # a0 = 4 (test 4 passed)
    
    # Test 5: BNE should NOT branch with same negative numbers
    addi    t0, zero, -15       # t0 = -15
    addi    t1, zero, -15       # t1 = -15
    bne     t0, t1, test5_fail  # should NOT branch
    addi    a0, a0, 1           # a0 = 5 (test 5 passed)
    beq     zero, zero, finish  # go to finish
test5_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
finish:      # expected result is 5 (all tests passed)
    bne     zero, zero, error   # should never branch
    beq     a0, a0, finish      # loop forever
error:
    addi    a0, zero, 999       # error state
    beq     a0, a0, error
