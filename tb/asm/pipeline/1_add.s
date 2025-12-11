.text
.globl main
main:
  li x1, 5
  add x2, x1, x1
  add x3, x2, x2
  add x4, x3, x3
  add a0, x4, x4
  
# a0 = 80
