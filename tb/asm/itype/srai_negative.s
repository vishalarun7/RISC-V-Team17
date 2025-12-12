.text
.globl main
# Test 3: SRAI (shift right arithmetic immediate) with negative
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, -16       # t0 = -16 (0xFFFFFFF0)
    srai    t1, t0, 2           # t1 = -16 >> 2 = -4 (sign-extends)
    addi    t2, zero, -4        # expected result
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
    jal     zero, finish
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
