module fetch_top #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32
)(
    input logic clk, 
    input logic rst, 
    input logic [1:0] PCSrc, 
    input logic [DATA_WIDTH-1:0] ALUResult,
    input logic [DATA_WIDTH-1:0] ImmExt,
    input logic stall; 
    input logic flush;
    
    output logic [ADDRESS_WIDTH-1:0] instr,
    output logic [DATA_WIDTH-1:0] PCPlus4
);

    logic [DATA_WIDTH-1:0] PC;
    logic [DATA_WIDTH-1:0] PCTarget;
    logic [DATA_WIDTH-1:0] PCNext;

    adder PCPlus4_adder(
        .in0 (PC),
        .in1 (32'd4),
        .out (PCPlus4)
    );

    adder PCTarget_adder(
        .in0(PC),
        .in1(ImmExt),
        .out (PCTarget)
    );

    pc_reg PC_REG(
        .clk (clk),
        .rst (rst), 
        .PCnext (PCNext),
        .PC (PC)
    );

    mux4 PCMux(
        .in0 (PCPlus4),
        .in1 (PCTarget),
        .in2 (ALUResult),
        .in3 (PC),
        .sel (PCSrc),
        .out (PCNext)
    );

    instr_mem INSTR_MEM(
        .addr (PC),
        .instr (instr)
    );
endmodule
