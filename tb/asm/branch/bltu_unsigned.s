.text
.globl main
# Test 2: BLTU with negative treated as large unsigned vs positive
# -1 = 0xFFFFFFFF is LARGER than any positive number in unsigned
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 100       # t0 = 100
    addi    t1, zero, -1        # t1 = 0xFFFFFFFF
    bltu    t0, t1, test_pass   # should branch (100 < 0xFFFFFFFF unsigned)
    addi    a0, a0, 100         # shouldn't execute (fail)
test_pass:
    addi    a0, a0, 1           # a0 = 1 (test passed)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
