.text
.globl main
# Test 4: BEQ with negative numbers
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, -10       # t0 = -10
    addi    t1, zero, -10       # t1 = -10
    beq     t0, t1, test_pass   # should branch (-10 == -10)
    addi    a0, a0, 100         # shouldn't execute (fail)
test_pass:
    addi    a0, a0, 1           # a0 = 1 (test passed)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
