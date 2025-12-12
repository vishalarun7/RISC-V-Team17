.text
.globl main
# Test 3: OR (bitwise or)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    li      t0, 0xF000          # t0 = 0x0000F000
    li      t1, 0x000F          # t1 = 0x0000000F
    or      t2, t0, t1          # t2 = 0x0000F00F
    li      t3, 0xF00F          # expected result
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
