.text
.globl main
# Test 1: SLL (shift left logical)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 1         # t0 = 1
    addi    t1, zero, 4         # t1 = 4 (shift amount)
    sll     t2, t0, t1          # t2 = 1 << 4 = 16
    addi    t3, zero, 16        # expected result
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
