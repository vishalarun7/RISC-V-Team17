module fetch_top #(
    parameter WIDTH = 32
)(
    input logic clk, 
    input logic rst, 
    input logic PCSrcE,  // 1 -> use PCTarget, 0 -> PC+4
    input logic Stall,
    input logic [WIDTH-1:0] PCTarget,     

    output logic [WIDTH-1:0] instr,
    output logic [WIDTH-1:0] PCPlus4,
    output logic [WIDTH-1:0] PC

);

    logic [WIDTH-1:0] PCNext;

    mux2 PCMUX(
        .in0 (PCPlus4),
        .in1 (PCTarget),
        .sel (PCSrcE),
        .out (PCNext)
    );
    
    pc_reg PC_REG(
        .clk (clk),
        .rst (rst), 
        .StallF (Stall),
        .PCnext (PCNext),
        .PC (PC)
    );
    adder PCPlus4_adder(
        .in0 (PC),
        .in1 (32'd4),
        .out (PCPlus4)
    );
    instr_mem INSTR_MEM(
        .addr (PC),
        .instr (instr)
    );
endmodule
