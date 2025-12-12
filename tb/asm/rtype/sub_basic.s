.text
.globl main
# Test 1: SUB (subtract)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 10        # t0 = 10
    addi    t1, zero, 3         # t1 = 3
    sub     t2, t0, t1          # t2 = 10 - 3 = 7
    addi    t3, zero, 7         # expected result
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
