.text
.globl main
# Test 2: BGE should branch when equal
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 7         # t0 = 7
    addi    t1, zero, 7         # t1 = 7
    bge     t0, t1, test_pass   # should branch (7 >= 7)
    addi    a0, a0, 100         # shouldn't execute (fail)
test_pass:
    addi    a0, a0, 1           # a0 = 1 (test passed)
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
