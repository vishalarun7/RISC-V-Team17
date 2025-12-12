.text
.globl main
# Test 1: SLLI (shift left logical immediate)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 1         # t0 = 1
    slli    t1, t0, 5           # t1 = 1 << 5 = 32
    addi    t2, zero, 32        # expected result
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
