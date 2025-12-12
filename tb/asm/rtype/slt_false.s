.text
.globl main
# Test 2: SLT (set less than - signed) - false case
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 10        # t0 = 10
    addi    t1, zero, 5         # t1 = 5
    slt     t2, t0, t1          # t2 = (10 < 5) = 0
    beq     t2, zero, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
