.text
.globl main
# Test BLTU (Branch if Less Than Unsigned) instruction
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    # Test 1: BLTU should branch when first < second (unsigned)
    addi    t0, zero, 3         # t0 = 3
    addi    t1, zero, 5         # t1 = 5
    bltu    t0, t1, test1_pass  # should branch (3 < 5)
    addi    a0, a0, 100         # shouldn't execute (fail)
test1_pass:
    addi    a0, a0, 1           # a0 = 1 (test 1 passed)
    
    # Test 2: BLTU should NOT branch when first >= second
    addi    t0, zero, 10        # t0 = 10
    addi    t1, zero, 5         # t1 = 5
    bltu    t0, t1, test2_fail  # should NOT branch (10 >= 5)
    addi    a0, a0, 1           # a0 = 2 (test 2 passed)
    beq     zero, zero, test3   # continue to test 3
test2_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
    # Test 3: BLTU should NOT branch when equal
test3:
    addi    t0, zero, 7         # t0 = 7
    addi    t1, zero, 7         # t1 = 7
    bltu    t0, t1, test3_fail  # should NOT branch (7 == 7)
    addi    a0, a0, 1           # a0 = 3 (test 3 passed)
    beq     zero, zero, test4   # continue to test 4
test3_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
    # Test 4: BLTU with negative numbers treated as unsigned
    # -1 as unsigned = 0xFFFFFFFF (very large), -5 = 0xFFFFFFFB
test4:
    addi    t0, zero, -5        # t0 = 0xFFFFFFFB (4294967291 unsigned)
    addi    t1, zero, -1        # t1 = 0xFFFFFFFF (4294967295 unsigned)
    bltu    t0, t1, test4_pass  # should branch (0xFFFFFFFB < 0xFFFFFFFF)
    addi    a0, a0, 100         # shouldn't execute (fail)
test4_pass:
    addi    a0, a0, 1           # a0 = 4 (test 4 passed)
    
    # Test 5: BLTU with negative treated as large unsigned vs positive
    # -1 = 0xFFFFFFFF is LARGER than any positive number in unsigned
    addi    t0, zero, 100       # t0 = 100
    addi    t1, zero, -1        # t1 = 0xFFFFFFFF
    bltu    t0, t1, test5_pass  # should branch (100 < 0xFFFFFFFF unsigned)
    addi    a0, a0, 100         # shouldn't execute (fail)
test5_pass:
    addi    a0, a0, 1           # a0 = 5 (test 5 passed)
    
    # Test 6: BLTU zero comparison
    addi    t0, zero, 0         # t0 = 0
    addi    t1, zero, 1         # t1 = 1
    bltu    t0, t1, test6_pass  # should branch (0 < 1)
    addi    a0, a0, 100         # shouldn't execute (fail)
test6_pass:
    addi    a0, a0, 1           # a0 = 6 (test 6 passed)
    
finish:      # expected result is 6 (all tests passed)
    beq     a0, a0, finish      # loop forever
