.text
.globl main
# Test 4: XOR (bitwise xor)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    li      t0, 0xFFFF          # t0 = 0x0000FFFF
    li      t1, 0xFF00          # t1 = 0x0000FF00
    xor     t2, t0, t1          # t2 = 0x000000FF
    addi    t3, zero, 0xFF      # expected result
    beq     t2, t3, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
