module top #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic trigger,
    output logic [DATA_WIDTH-1:0] a0
);

    // regs and int sigs
    logic [DATA_WIDTH-1:0] PC, PCNext, PCPlus4, PCTarget;
    logic [DATA_WIDTH-1:0] Instr;
    logic [DATA_WIDTH-1:0] SrcA, SrcB, WriteData;
    logic [DATA_WIDTH-1:0] ALUResult;
    logic [DATA_WIDTH-1:0] ReadData;
    logic [DATA_WIDTH-1:0] Result;
    logic [DATA_WIDTH-1:0] ImmExt;
    logic [DATA_WIDTH-1:0] RD1, RD2;
    

    // ctrl sigs
    logic RegWrite, MemWrite, ALUSrc;
    logic [1:0] ResultSrc;
    logic Zero, Negative;
    logic [1:0] PCSrc;
    logic [2:0] ImmSrc;
    logic [3:0] ALUControl;
    logic AddrMode;
    

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            PC <= 32'h00000000;
        else
            PC <= PCNext;
    end
    

    assign PCPlus4 = PC + 32'd4;

    assign PCTarget = PC + ImmExt;
    

    always_comb begin
        case (PCSrc)
            2'b00: PCNext = PCPlus4;
            2'b01: PCNext = PCTarget;
            2'b10: PCNext = ALUResult;
            2'b11: PCNext = PC;
            default: PCNext = PCPlus4;
        endcase
    end

    instr_mem #(
        .ADDRESS_WIDTH(DATA_WIDTH)
    ) INSTR_MEM (
        .addr(PC),
        .instr(Instr)
    );
    control CONTROL (
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[30]),
        .Zero(Zero),
        .Negative(Negative),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ResultSrc(ResultSrc),
        .Branch(),
        .Jump(),
        .ImmSrc(ImmSrc),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl),
        .AddrMode(AddrMode)
    );
    
    regfile #(
        .ADDRESS_WIDTH(DATA_WIDTH)
    ) REG_FILE (
        .clk(clk),
        .AD1(Instr[19:15]),
        .AD2(Instr[24:20]), 
        .AD3(Instr[11:7]),
        .WE3(RegWrite),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2),
        .a0(a0)
    );
    immext IMM_EXT (
        .instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );
    

    assign SrcA = RD1;
   
    assign SrcB = ALUSrc ? ImmExt : RD2; // alu reads from rd2 or imm based on alusrc signal    

    alu #(
        .DATA_WIDTH(DATA_WIDTH)
    ) ALU (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .Negative(Negative)
    );
    
    datamem #(
        .WIDTH(DATA_WIDTH)
    ) DATA_MEM (
        .aluresult(ALUResult),
        .RD2(RD2),
        .clk(clk),
        .MemWrite(MemWrite),
        .AddrMode(AddrMode),
        .RD(ReadData)
    );
    
    always_comb begin
        case (ResultSrc)
            2'b00: Result = ALUResult;   // ALU result
            2'b01: Result = ReadData;    // Memory read
            2'b10: Result = PCPlus4;     // JAL/JALR (return address)
            2'b11: Result = ImmExt;      // LUI immediate
            default: Result = ALUResult;
        endcase
    end

endmodule
