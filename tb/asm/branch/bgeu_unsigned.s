.text
.globl main
# Test 2: BGEU with negative as large unsigned vs positive
# -1 = 0xFFFFFFFF is LARGER than any positive number
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, -1        # t0 = 0xFFFFFFFF
    addi    t1, zero, 100       # t1 = 100
    bgeu    t0, t1, test_pass   # should branch (0xFFFFFFFF >= 100)
    addi    a0, a0, 100         # shouldn't execute (fail)
test_pass:
    addi    a0, a0, 1           # a0 = 1 (test passed)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
