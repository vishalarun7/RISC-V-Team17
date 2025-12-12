.text
.globl main
# Test BEQ (Branch if Equal) instruction
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    # Test 1: BEQ should branch when values are equal
    addi    t0, zero, 5         # t0 = 5
    addi    t1, zero, 5         # t1 = 5
    beq     t0, t1, test1_pass  # should branch (5 == 5)
    addi    a0, a0, 100         # shouldn't execute (fail)
test1_pass:
    addi    a0, a0, 1           # a0 = 1 (test 1 passed)
    
    # Test 2: BEQ should NOT branch when values are different
    addi    t0, zero, 5         # t0 = 5
    addi    t1, zero, 3         # t1 = 3
    beq     t0, t1, test2_fail  # should NOT branch (5 != 3)
    addi    a0, a0, 1           # a0 = 2 (test 2 passed)
    beq     zero, zero, test3   # continue to test 3
test2_fail:
    addi    a0, a0, 100         # shouldn't execute (fail)
    
    # Test 3: BEQ with zero
test3:
    addi    t0, zero, 0         # t0 = 0
    beq     t0, zero, test3_pass # should branch (0 == 0)
    addi    a0, a0, 100         # shouldn't execute (fail)
test3_pass:
    addi    a0, a0, 1           # a0 = 3 (test 3 passed)
    
    # Test 4: BEQ with negative numbers
    addi    t0, zero, -10       # t0 = -10
    addi    t1, zero, -10       # t1 = -10
    beq     t0, t1, test4_pass  # should branch (-10 == -10)
    addi    a0, a0, 100         # shouldn't execute (fail)
test4_pass:
    addi    a0, a0, 1           # a0 = 4 (test 4 passed)
    
    # Test 5: BEQ with large numbers
    li      t0, 0x7FFFFFFF      # t0 = max positive int
    li      t1, 0x7FFFFFFF      # t1 = max positive int
    beq     t0, t1, test5_pass  # should branch
    addi    a0, a0, 100         # shouldn't execute (fail)
test5_pass:
    addi    a0, a0, 1           # a0 = 5 (test 5 passed)
    
finish:      # expected result is 5 (all tests passed)
    beq     a0, a0, finish      # loop forever
