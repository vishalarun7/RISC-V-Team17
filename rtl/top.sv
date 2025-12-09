module top #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 32
) (
    input  logic clk,
    input  logic rst,
    input  logic trigger,
    output logic [DATA_WIDTH-1:0] a0
);
    // ========== FETCH STAGE SIGNALS ==========
    logic [DATA_WIDTH-1:0] instrF, PCPlus4F, PCF;
    logic [1:0] PCSrcE;
    
    // ========== DECODE STAGE SIGNALS ==========
    logic [DATA_WIDTH-1:0] instrD, PCPlus4D, PCD;
    logic [DATA_WIDTH-1:0] RD1D, RD2D, ImmExtD;
    logic [4:0] Rs1D, Rs2D, RdD;
    logic [2:0] ImmSrcD;
    logic RegWriteD, MemWriteD, ALUSrcD, AddrModeD, BranchD, JumpD;
    logic [1:0] ResultSrcD;
    logic [3:0] ALUControlD;
    logic MemReadD;
    
    // ========== EXECUTE STAGE SIGNALS ==========
    logic [DATA_WIDTH-1:0] RD1E, RD2E, ImmExtE, PCE, PCPlus4E;
    logic [DATA_WIDTH-1:0] SrcAE, SrcBE, ALUResultE, WriteDataE;
    logic [4:0] Rs1E, Rs2E, RdE;
    logic RegWriteE, MemWriteE, ALUSrcE, AddrModeE, BranchE, JumpE;
    logic [1:0] ResultSrcE;
    logic [3:0] ALUControlE;
    logic ZeroE, NegativeE;
    logic MemReadE;
    
    // ========== MEMORY STAGE SIGNALS ==========
    logic [DATA_WIDTH-1:0] ALUResultM, WriteDataM, PCPlus4M;
    logic [DATA_WIDTH-1:0] ReadDataM;
    logic [4:0] RdM;
    logic RegWriteM, MemWriteM, AddrModeM, MemReadM;
    logic [1:0] ResultSrcM;
    
    // ========== WRITEBACK STAGE SIGNALS ==========
    logic [DATA_WIDTH-1:0] ALUResultW, ReadDataW, PCPlus4W, ResultW;
    logic [4:0] RdW;
    logic RegWriteW;
    logic [1:0] ResultSrcW;
    
    // ========== HAZARD UNIT SIGNALS ==========
    logic StallF, StallD, FlushE, FlushD;
    logic [1:0] ForwardAE, ForwardBE;

    logic [DATA_WIDTH-1:0] a0_regfile;

    // ----------------------------
    // FETCH STAGE
    // ----------------------------
    fetch_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(ADDR_WIDTH)
    ) fetch_inst (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrcE),
        .ALUResult(ALUResultE),
        .ImmExt(ImmExtE),
        .stall(StallF),
        .flush(FlushD),
        .instr(instrF),
        .PCPlus4(PCPlus4F)
    );
    
    // Need to extract PC from fetch for pipeline register
    assign PCF = PCPlus4F - 4;

    // ----------------------------
    // FETCH/DECODE PIPELINE REGISTER
    // ----------------------------
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

    // ----------------------------
    // DECODE STAGE
    // ----------------------------
    
    // Extract register addresses
    assign Rs1D = instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign RdD = instrD[11:7];
    
    // Control Unit
    control control_inst (
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
    
    assign MemReadD = (instrD[6:0] == 7'b0000011); // Load instruction
    
    // Register File
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
    assign a0 = a0_regfile;
    
    // Immediate Extension
    immext immext_inst (
        .instr(instrD),
        .ImmSrc(ImmSrcD),
        .ImmExt(ImmExtD)
    );

    // ----------------------------
    // DECODE/EXECUTE PIPELINE REGISTER
    // ----------------------------
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
        .MemReadD(MemReadD),
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
        .MemReadE(MemReadE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .pcE(PCE),
        .PCPlus4E(PCPlus4E),
        .ImmExtE(ImmExtE)
    );

    // ----------------------------
    // EXECUTE STAGE
    // ----------------------------
    
    // Forwarding Multiplexers
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
    
    // ALU
    alu #(.DATA_WIDTH(DATA_WIDTH)) alu_inst (
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .ALUResult(ALUResultE),
        .Zero(ZeroE),
        .Negative(NegativeE)
    );
    
    // Branch/Jump Logic
    assign PCSrcE = {1'b0, (JumpE | (BranchE & ZeroE))};

    // ----------------------------
    // EXECUTE/MEMORY PIPELINE REGISTER
    // ----------------------------
    execute_memory #(
        .DATA_WIDTH(DATA_WIDTH)
    ) em_reg (
        .clk(clk),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .MemReadE(MemReadE),
        .ResultSrcE(ResultSrcE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .AddrModeE(AddrModeE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .MemReadM(MemReadM),
        .ResultSrcM(ResultSrcM),
        .RdM(RdM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .AddrModeM(AddrModeM)
    );

    // ----------------------------
    // MEMORY STAGE
    // ----------------------------
    datamem #(.WIDTH(DATA_WIDTH)) datamem_inst (
        .clk(clk),
        .aluresult(ALUResultM),
        .RD2(WriteDataM),
        .MemWrite(MemWriteM),
        .AddrMode(AddrModeM),
        .RD(ReadDataM)
    );

    // ----------------------------
    // MEMORY/WRITEBACK PIPELINE REGISTER
    // ----------------------------
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

    // ----------------------------
    // WRITEBACK STAGE
    // ----------------------------
    always_comb begin
        case (ResultSrcW)
            2'b00: ResultW = ALUResultW;
            2'b01: ResultW = ReadDataW;
            2'b10: ResultW = PCPlus4W;
            2'b11: ResultW = ALUResultW; // LUI handled in ALU
            default: ResultW = ALUResultW;
        endcase
    end

    // ----------------------------
    // HAZARD UNIT
    // ----------------------------
    hazard_unit #(
        .DATA_WIDTH(DATA_WIDTH)
    ) hazard_inst (
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushE(FlushE)
    );
    
    // Control hazard: flush decode stage on branch/jump taken
    assign FlushD = PCSrcE[0];

endmodule
