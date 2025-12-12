.text
.globl main
# Test 2: LUI followed by ADDI (forming a large immediate)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    lui     t0, 0xABCD0         # t0 = 0xABCD0000
    addi    t0, t0, 0x123       # t0 = 0xABCD0000 + 0x123 = 0xABCD0123
    li      t1, 0xABCD0123      # expected result
    beq     t0, t1, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
