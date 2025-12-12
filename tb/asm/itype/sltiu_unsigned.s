.text
.globl main
# Test 3: SLTIU with sign-extended immediate (treated as unsigned)
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 100       # t0 = 100
    sltiu   t1, t0, -1          # t1 = (100 < 0xFFFFFFFF unsigned) = 1
    addi    t2, zero, 1         # expected result
    beq     t1, t2, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
