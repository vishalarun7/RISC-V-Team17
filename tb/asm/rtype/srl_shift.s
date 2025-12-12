.text
.globl main
# Test 2: SRL (shift right logical)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 64        # t0 = 64
    addi    t1, zero, 2         # t1 = 2 (shift amount)
    srl     t2, t0, t1          # t2 = 64 >> 2 = 16
    addi    t3, zero, 16        # expected result
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
