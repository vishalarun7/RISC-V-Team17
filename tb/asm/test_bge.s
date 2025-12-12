.text
.globl main
# Test BGE (Branch if Greater or Equal - signed) instruction
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    # Test 1: BGE should branch when first > second
    addi    t0, zero, 8         # t0 = 8
    addi    t1, zero, 5         # t1 = 5
    bge     t0, t1, test1_pass  # should branch (8 >= 5)
    addi    a0, a0, 100         # shouldn't execute (fail)
test1_pass:
    addi    a0, a0, 1           # a0 = 1 (test 1 passed)
    
    # Test 2: BGE should branch when equal
    addi    t0, zero, 7         # t0 = 7
    addi    t1, zero, 7         # t1 = 7
    bge     t0, t1, test2_pass  # should branch (7 >= 7)
    addi    a0, a0, 100         # shouldn't execute (fail)
test2_pass:
    addi    a0, a0, 1           # a0 = 2 (test 2 passed)
    
    # Test 3: BGE should NOT branch when first < second
    addi    t0, zero, 3         # t0 = 3
    addi    t1, zero, 10        # t1 = 10
    bge     t0, t1, test3_fail  # should NOT branch (3 < 10)
    addi    a0, a0, 1           # a0 = 3 (test 3 passed)
    beq     zero, zero, test4   # continue to test 4
test3_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
    # Test 4: BGE with negative numbers (signed comparison)
test4:
    addi    t0, zero, -5        # t0 = -5
    addi    t1, zero, -10       # t1 = -10
    bge     t0, t1, test4_pass  # should branch (-5 >= -10)
    addi    a0, a0, 100         # shouldn't execute (fail)
test4_pass:
    addi    a0, a0, 1           # a0 = 4 (test 4 passed)
    
    # Test 5: BGE with positive and negative (signed)
    addi    t0, zero, 1         # t0 = 1
    addi    t1, zero, -1        # t1 = -1
    bge     t0, t1, test5_pass  # should branch (1 >= -1)
    addi    a0, a0, 100         # shouldn't execute (fail)
test5_pass:
    addi    a0, a0, 1           # a0 = 5 (test 5 passed)
    
    # Test 6: BGE zero comparison
    bge     zero, zero, test6_pass # should branch (0 >= 0)
    addi    a0, a0, 100         # shouldn't execute (fail)
test6_pass:
    addi    a0, a0, 1           # a0 = 6 (test 6 passed)
    
    # Test 7: BGE should NOT branch (negative < positive)
    addi    t0, zero, -1        # t0 = -1
    addi    t1, zero, 0         # t1 = 0
    bge     t0, t1, test7_fail  # should NOT branch (-1 < 0)
    addi    a0, a0, 1           # a0 = 7 (test 7 passed)
    beq     zero, zero, finish  # go to finish
test7_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
finish:      # expected result is 7 (all tests passed)
    beq     a0, a0, finish      # loop forever
