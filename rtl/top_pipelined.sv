module top #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 32
) (
    input  logic clk,
    input  logic rst,
    input  logic trigger,
    output logic [DATA_WIDTH-1:0] a0
);

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
