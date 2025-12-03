module top #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 32
) (
    input  logic clk,
    input  logic rst,
    input  logic trigger,
    output logic [DATA_WIDTH-1:0] a0
);

            //IF signals 
    logic [1:0]  PCSrcE;                      
    logic [DATA_WIDTH-1:0] PCTargetE;         
    logic [DATA_WIDTH-1:0] PCPlus4F;          
    logic [ADDR_WIDTH-1:0] instrF;

             //Stall/flush controls 
    logic stallF, stallD, flushD, flushE;

            //IF/ID pipeline regs 
    logic [DATA_WIDTH-1:0] PCPlus4D;
    logic [ADDR_WIDTH-1:0] instrD;

            //ID signals 
    logic RegWriteD, MemWriteD, AddrModeD, ALUSrcD, MemReadD;
    logic [1:0] ResultSrcD;
    logic BranchD, JumpD;
    logic [2:0] ImmSrcD;
    logic [3:0] ALUControlD;

    logic [DATA_WIDTH-1:0] ImmExtD;
    logic [DATA_WIDTH-1:0] RD1D, RD2D;
    logic [4:0] rs1D, rs2D, rdD;

            //ID/EX pipeline regs 
    logic RegWriteE, MemWriteE, AddrModeE, ALUSrcE, MemReadE;
    logic [1:0] ResultSrcE;
    logic BranchE, JumpE;
    logic [3:0] ALUControlE;
    logic [DATA_WIDTH-1:0] ImmExtE, RD1E, RD2E, PCPlus4E;
    logic [4:0] rs1E, rs2E, rdE;

            //EX signals 
    logic [DATA_WIDTH-1:0] SrcAE, SrcBE, ALUResultE;
    logic ZeroE, NegativeE;

            //EX/MEM pipeline regs 
    logic RegWriteM, MemWriteM, MemReadM, AddrModeM;
    logic [1:0] ResultSrcM;
    logic [DATA_WIDTH-1:0] ALUResultM, WriteDataM, PCPlus4M;
    logic [4:0] rdM;

            //MEM signals 
    logic [DATA_WIDTH-1:0] ReadDataM;

            //MEM/WB pipeline regs 
    logic RegWriteW;
    logic [1:0] ResultSrcW;
    logic [DATA_WIDTH-1:0] ALUResultW, ReadDataW, PCPlus4W, ImmExtW;
    logic [4:0] rdW;

            //WB signals 
    logic [DATA_WIDTH-1:0] ResultW;
    logic [DATA_WIDTH-1:0] a0_regfile;

            //Forwarding controls 
    // 00: no forward, 10: from EX/MEM, 01: from MEM/WB
    logic [1:0] forwardAE, forwardBE;


    fetch_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(ADDR_WIDTH)
    ) fetch_inst (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrc),
        .ALUResult(ALUResult),
        .ImmExt(ImmExt),
        .instr(instr),
        .PCPlus4(PCPlus4)
    );

    control control_inst (
        .op (instr[6:0]),
        .funct3 (instr[14:12]),
        .funct7 (instr[30]),
        .Zero (Zero),
        .Negative (Negative),
        .RegWrite (RegWrite),
        .MemWrite (MemWrite),
        .ALUSrc (ALUSrc),
        .ResultSrc (ResultSrc),
        .PCSrc (PCSrc),
        .Branch (Branch),
        .Jump (Jump),
        .ImmSrc (ImmSrc),
        .ALUControl (ALUControl),
        .AddrMode (AddrMode)
    );

    regfile regfile_inst (
        .clk (clk),
        .AD1(instr[19:15]),
        .AD2(instr[24:20]),
        .AD3(instr[11:7]),
        .WE3 (RegWrite),
        .WD3 (WD3),
        .RD1 (RD1),
        .RD2 (RD2),
        .a0 (a0_regfile)
    );

    immext immext_inst (
        .instr (instr),
        .ImmSrc (ImmSrc),
        .ImmExt (ImmExt)
    );

    alu #(
        .DATA_WIDTH(DATA_WIDTH)
    ) alu_inst (
        .SrcA (RD1),
        .SrcB (ALUSrc ? ImmExt : RD2),
        .ALUControl (ALUControl),
        .ALUResult (ALUResult),
        .Zero (Zero),
        .Negative (Negative)
    );
    
    datamem #(
        .WIDTH(DATA_WIDTH)
    ) datamem_inst (
        .clk (clk),
        .aluresult (ALUResult),
        .RD2 (RD2),
        .MemWrite (MemWrite),
        .AddrMode (AddrMode),
        .RD (ReadData)
    );

    // Result multiplexer (selects between ALU result, memory read data, etc.)
    always_comb begin
        case (ResultSrc)
            2'b00: Result = ALUResult;      // ALU result
            2'b01: Result = ReadData;       // Memory read data
            2'b10: Result = PCPlus4;        // PC+4 (for JAL/JALR)
            2'b11: Result = ImmExt;         // Immediate (for LUI)
            default: Result = ALUResult;
        endcase
    end

    // Write data multiplexer for register file
    assign WD3 = Result;
    assign a0 = a0_regfile;

endmodule
