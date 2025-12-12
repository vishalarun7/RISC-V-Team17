.text
.globl main
# Test 3: SRA (shift right arithmetic) with negative number
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, -8        # t0 = -8 (0xFFFFFFF8)
    addi    t1, zero, 1         # t1 = 1 (shift amount)
    sra     t2, t0, t1          # t2 = -8 >> 1 = -4 (sign-extends)
    addi    t3, zero, -4        # expected result (0xFFFFFFFC)
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
