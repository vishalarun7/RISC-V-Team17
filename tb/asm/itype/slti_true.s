.text
.globl main
# Test 1: SLTI (set less than immediate - signed) - true case
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 5         # t0 = 5
    slti    t1, t0, 10          # t1 = (5 < 10) = 1
    addi    t2, zero, 1         # expected result
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
