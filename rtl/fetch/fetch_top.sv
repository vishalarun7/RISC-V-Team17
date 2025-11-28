#include "instr_mem.sv"
#include "pc_register.sv"
#include "control.sv"

module fetch_top(
    parameter WIDTH = 32, 
    parameter ADDRESS_WIDTH = 32, 
)(
    input logic clk, 
    input logic rst, 
    input logic [WIDTH-1:0] PCnext,
    input logic [1:0] PCSrc, 
    input logic 
    ouput logic [ADDRESS_WIDTH-1:0] instr

);(
    logic [WIDTH-1:0] PC,
    logic [ADDRESS_WIDTH-1:0] addr
)

    addr PCPlus4(
        PCPlus4 = PC + 4;
    )

    addr PCTarget(
        PCTarget = PC + Immext;
    )
    pc_reg PC_REG(
        .clk (clk),
        .rst (rst), 
        .PCnext (PCnext),
        .PC (PC)
    );

    instr_mem INSTR_MEM(
        .addr (addr)
        .instr (instr)
    )