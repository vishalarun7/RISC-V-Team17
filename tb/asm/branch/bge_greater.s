.text
.globl main
# Test 1: BGE should branch when first > second
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 8         # t0 = 8
    addi    t1, zero, 5         # t1 = 5
    bge     t0, t1, test_pass   # should branch (8 >= 5)
    addi    a0, a0, 100         # shouldn't execute (fail)
test_pass:
    addi    a0, a0, 1           # a0 = 1 (test passed)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
