module top #(
    parameter DATA_WIDTH = 32,
) (
    input  logic clk,
    input  logic rst,
    input  logic trigger,
    output logic [DATA_WIDTH-1:0] a0
);
    logic [DATA_WIDTH-1:0] instrF, PCPlus4F, PCF;
    logic PCSrcE;

    logic [DATA_WIDTH-1:0] instrD, PCPlus4D, PCD;
    logic [DATA_WIDTH-1:0] RD1D, RD2D, ImmExtD;
    logic [4:0] Rs1D, Rs2D, RdD;
    logic [2:0] ImmSrcD;
    logic RegWriteD, MemWriteD, ALUSrcD, AddrModeD, BranchD, JumpD;
    logic [1:0] ResultSrcD;
    logic [3:0] ALUControlD;

    logic [DATA_WIDTH-1:0] RD1E, RD2E, ImmExtE, PCE, PCPlus4E;
    logic [DATA_WIDTH-1:0] SrcAE, SrcBE, ALUResultE, WriteDataE, PCTargetE;
    logic [4:0] Rs1E, Rs2E, RdE;
    logic RegWriteE, MemWriteE, ALUSrcE, AddrModeE, BranchE, JumpE;
    logic [1:0] ResultSrcE;
    logic [3:0] ALUControlE;
    logic ZeroE;

    logic [DATA_WIDTH-1:0] ALUResultM, WriteDataM, PCPlus4M;
    logic [DATA_WIDTH-1:0] ReadDataM;
    logic [4:0] RdM;
    logic RegWriteM, MemWriteM, AddrModeM;
    logic [1:0] ResultSrcM;

    logic [DATA_WIDTH-1:0] ALUResultW, ReadDataW, PCPlus4W, ResultW;
    logic [4:0] RdW;
    logic RegWriteW;
    logic [1:0] ResultSrcW;

    logic StallF, StallD, FlushD, FlushE;
    logic [1:0] ForwardAE, ForwardBE;

    logic [DATA_WIDTH-1:0] a0_regfile;

    fetch_top #(
    .WIDTH(DATA_WIDTH)
    ) fetch_stage (
        .clk      (clk),
        .rst      (rst),
        .PCSrcE   (PCSrcE),
        .Stall    (StallF),
        .PCTarget (PCTargetE),
        .instr    (instrF),
        .PCPlus4  (PCPlus4F)
    );


    assign PCF = PCPlus4F - 4;
    fetch_decode #(
        .DATA_WIDTH(DATA_WIDTH)
    ) fd_reg (
        .clk(clk),
        .FlushD(FlushD),
        .StallD(StallD),
        .PCPlus4F(PCPlus4F),
        .instr(instrF),
        .pcF(PCF),
        .PCPlus4D(PCPlus4D),
        .instrD(instrD),
        .pcD(PCD)
    );

    assign Rs1D = instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign RdD = instrD[11:7];

    control control_unit(
        .op(instrD[6:0]),
        .funct3(instrD[14:12]),
        .funct7(instrD[30]),
        .RegWrite(RegWriteD),
        .MemWrite(MemWriteD),
        .ALUSrc(ALUSrcD),
        .ResultSrc(ResultSrcD),
        .Branch(BranchD),
        .Jump(JumpD),
        .ImmSrc(ImmSrcD),
        .ALUControl(ALUControlD),
        .AddrMode(AddrModeD)
    );

    regfile regfile_inst (
        .clk(clk),
        .AD1(Rs1D),
        .AD2(Rs2D),
        .AD3(RdW),
        .WE3(RegWriteW),
        .WD3(ResultW),
        .RD1(RD1D),
        .RD2(RD2D),
        .a0(a0_regfile)
    );

    immext immext_inst (
        .instr(instrD),
        .ImmSrc(ImmSrcD),
        .ImmExt(ImmExtD)
    );

    decode_execute #(
        .DATA_WIDTH(DATA_WIDTH)
    ) de_reg (
        .clk(clk),
        .FlushE(FlushE),
        .AddrModeD(AddrModeD),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUSrcD(ALUSrcD),
        .ResultSrcD(ResultSrcD),
        .ALUControlD(ALUControlD),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .pcD(PCD),
        .PCPlus4D(PCPlus4D),
        .ImmExtD(ImmExtD),
        .AddrModeE(AddrModeE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .pcE(PCE),
        .PCPlus4E(PCPlus4E),
        .ImmExtE(ImmExtE)
    );

    assign PCTargetE = PCE + ImmExtE;
    logic BranchTakenE;
    assign BranchTakenE = BranchE & ZeroE;
    assign PCSrcE = BranchTakenE | JumpE;

    always_comb begin
        case (ForwardAE)
            2'b00: SrcAE = RD1E;
            2'b01: SrcAE = ResultW;
            2'b10: SrcAE = ALUResultM;
            default: SrcAE = RD1E;
        endcase

        case (ForwardBE)
            2'b00: WriteDataE = RD2E;
            2'b01: WriteDataE = ResultW;
            2'b10: WriteDataE = ALUResultM;
            default: WriteDataE = RD2E;
        endcase
    end
    
    assign SrcBE = ALUSrcE ? ImmExtE : WriteDataE;

    alu #(.DATA_WIDTH(DATA_WIDTH)) 
    alu_inst (
    .SrcA(SrcAE),
    .SrcB(SrcBE),
    .ALUControl(ALUControlE),
    .ALUResult(ALUResultE),
    .Zero(ZeroE),
    .Negative()
    );

    execute_memory #(
        .DATA_WIDTH(DATA_WIDTH)
    ) em_reg (
        .clk(clk),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .AddrModeE(AddrModeE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RdM(RdM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .AddrModeM(AddrModeM)
    );

     datamem #(.WIDTH(DATA_WIDTH)) datamem_inst (
        .clk(clk),
        .aluresult(ALUResultM),
        .RD2(WriteDataM),
        .MemWrite(MemWriteM),
        .AddrMode(AddrModeM),
        .RD(ReadDataM)
    );

    memory_writeback #(
        .DATA_WIDTH(DATA_WIDTH)
    ) mw_reg (
        .clk(clk),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .RdM(RdM),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .PCPlus4M(PCPlus4M),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RdW(RdW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W)
    );

    always_comb begin
        case (ResultSrcW)
            2'b00: ResultW = ALUResultW;
            2'b01: ResultW = ReadDataW;
            2'b10: ResultW = PCPlus4W;
            default: ResultW = ALUResultW;
        endcase
    end


    hazard_unit hazard (
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .RdM(RdM),
    .RdW(RdW),
    .ResultSrcE(ResultSrcE),
    .PCSrcE(PCSrcE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .StallD(StallD),
    .StallF(StallF),
    .FlushE(FlushE),
    .FlushD(FlushD)
);

endmodule