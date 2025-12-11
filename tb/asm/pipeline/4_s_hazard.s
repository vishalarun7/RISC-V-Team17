.text
.globl main
main:
  li x1, 4
  sw x1, 0(x0)
  lw x2, 0(x0)
  add a0, x1, x2

# a0 = 8
