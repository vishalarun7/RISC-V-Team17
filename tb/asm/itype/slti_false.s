.text
.globl main
# Test 2: SLTI (set less than immediate - signed) - false case
main:
    addi    a0, zero, 0         # a0 = 0 (result counter)
    
    addi    t0, zero, 15        # t0 = 15
    slti    t1, t0, 10          # t1 = (15 < 10) = 0
    beq     t1, zero, test_pass
    addi    a0, a0, 100         # fail
test_pass:
    addi    a0, a0, 1           # a0 = 1
    
finish:      # expected result is 1
    beq     a0, a0, finish      # loop forever
