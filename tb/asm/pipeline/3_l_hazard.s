.text
.globl main
main:
  li t0, 3
  sw t0, 0(t0)
  lw t1, 0(t0)
  add x2, t1, t1
  addi a0, x2, 4


  # a0 = 10
  