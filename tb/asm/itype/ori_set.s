.text
.globl main
# Test 2: ORI (or immediate)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    li      t0, 0xF000          # t0 = 0x0000F000
    ori     t1, t0, 0x00F       # t1 = 0x0000F000 | 0x00F = 0xF00F
    li      t2, 0xF00F          # expected result
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
