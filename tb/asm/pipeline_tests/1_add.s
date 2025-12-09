.text
.globl main
main:
    LI x1, 5
    ADD x2, x1, x1
    ADD x3, x2, x2
    ADD x4, x3, x3
    ADD a0, x4, x4
    J finish

finish:
    J finish