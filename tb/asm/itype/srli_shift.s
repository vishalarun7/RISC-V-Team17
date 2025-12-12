.text
.globl main
# Test 2: SRLI (shift right logical immediate)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    li      t0, 128             # t0 = 128
    srli    t1, t0, 3           # t1 = 128 >> 3 = 16
    addi    t2, zero, 16        # expected result
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
