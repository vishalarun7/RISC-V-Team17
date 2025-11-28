#include "instr_mem.sv"
#include "pc_register.sv"
#include "control.sv"
#include "ImmExt.sv"
#include "4mux.sv"

module fetch_top(
    parameter WIDTH = 32, 
)(
    input logic clk, 
    input logic rst, 
    input logic [1:0] PCSrc, 
    input logic [DATA_WIDTH-1:0] Result,
    input logic [DATA_WIDTH-1:0] ImmExt,
    ouput logic [ADDRESS_WIDTH-1:0] instr

);(
    logic [DATA_WIDTH-1:0] PC;
    logic [DATA_WIDTH-1:0] PCPlus4;
    logic [DATA_WIDTH-1:0] PCTarget;
    logic [DATA_WIDTH-1:0] PCNext;
)

    adder PCPlus4(
        .in0 (PC),
        .in1 (32'd4),
        .out (PCPlus4)
    );

    adder PCTarget(
        .in0(PC),
        .in1(ImmExt)
        .out (PCTarget)
    );

    pc_reg PC_REG(
        .clk (clk),
        .rst (rst), 
        .PCnext (PCnext),
        .C (PC)
    );

    4mux PCMux(
        .in0 (PCPlus4),
        .in1 (PCTarget),
        .in2 (Result),
        .in3 (PC),
        .sel (PCSrc),
        .out (PCNext)
    );

    instr_mem INSTR_MEM(
        .addr (PC)
        .instr (instr)
    );
endmodule
