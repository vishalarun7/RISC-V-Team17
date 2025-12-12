.text
.globl main
# Test 3: BEQ with zero
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 0         # t0 = 0
    beq     t0, zero, test_pass # should branch (0 == 0)
    addi    a0, a0, 100         # shouldn't execute (fail)
test_pass:
    addi    a0, a0, 1           # a0 = 1 (test passed)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
