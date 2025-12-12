.text
.globl main
# Test 2: AND (bitwise and)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    li      t0, 0xFF0F          # t0 = 0x0000FF0F
    li      t1, 0xF0F0          # t1 = 0x0000F0F0
    and     t2, t0, t1          # t2 = 0x0000F000
    li      t3, 0xF000          # expected result
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
