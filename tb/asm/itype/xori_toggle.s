.text
.globl main
# Test 3: XORI (xor immediate)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    li      t0, 0xAAAA          # t0 = 0x0000AAAA
    xori    t1, t0, 0x7FF       # t1 = 0x0000AAAA ^ 0x7FF = 0xAD55
    li      t2, 0xAD55          # expected result (corrected)
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
    jal     zero, finish
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
