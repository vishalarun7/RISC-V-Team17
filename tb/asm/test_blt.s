.text
.globl main
# Test BLT (Branch if Less Than - signed) instruction
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    # Test 1: BLT should branch when first < second (positive numbers)
    addi    t0, zero, 3         # t0 = 3
    addi    t1, zero, 5         # t1 = 5
    blt     t0, t1, test1_pass  # should branch (3 < 5)
    addi    a0, a0, 100         # shouldn't execute (fail)
test1_pass:
    addi    a0, a0, 1           # a0 = 1 (test 1 passed)
    
    # Test 2: BLT should NOT branch when first >= second
    addi    t0, zero, 8         # t0 = 8
    addi    t1, zero, 5         # t1 = 5
    blt     t0, t1, test2_fail  # should NOT branch (8 >= 5)
    addi    a0, a0, 1           # a0 = 2 (test 2 passed)
    beq     zero, zero, test3   # continue to test 3
test2_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
    # Test 3: BLT should NOT branch when equal
test3:
    addi    t0, zero, 7         # t0 = 7
    addi    t1, zero, 7         # t1 = 7
    blt     t0, t1, test3_fail  # should NOT branch (7 == 7)
    addi    a0, a0, 1           # a0 = 3 (test 3 passed)
    beq     zero, zero, test4   # continue to test 4
test3_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
    # Test 4: BLT with negative numbers (signed comparison)
test4:
    addi    t0, zero, -10       # t0 = -10
    addi    t1, zero, -5        # t1 = -5
    blt     t0, t1, test4_pass  # should branch (-10 < -5)
    addi    a0, a0, 100         # shouldn't execute (fail)
test4_pass:
    addi    a0, a0, 1           # a0 = 4 (test 4 passed)
    
    # Test 5: BLT with negative and positive (signed)
    addi    t0, zero, -1        # t0 = -1
    addi    t1, zero, 1         # t1 = 1
    blt     t0, t1, test5_pass  # should branch (-1 < 1)
    addi    a0, a0, 100         # shouldn't execute (fail)
test5_pass:
    addi    a0, a0, 1           # a0 = 5 (test 5 passed)
    
    # Test 6: BLT zero comparison
    addi    t0, zero, -5        # t0 = -5
    blt     t0, zero, test6_pass # should branch (-5 < 0)
    addi    a0, a0, 100         # shouldn't execute (fail)
test6_pass:
    addi    a0, a0, 1           # a0 = 6 (test 6 passed)
    
finish:      # expected result is 6 (all tests passed)
    beq     a0, a0, finish      # loop forever
