.text
.globl main
# Test 1: SLT (set less than - signed) - true case
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 5         # t0 = 5
    addi    t1, zero, 10        # t1 = 10
    slt     t2, t0, t1          # t2 = (5 < 10) = 1
    addi    t3, zero, 1         # expected result
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
