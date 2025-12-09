module top #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 32
) (
    input  logic clk,
    input  logic rst,
    input  logic trigger,
    output logic [DATA_WIDTH-1:0] a0
);
    logic [DATA_WIDTH-1:0] instr, PCPlus4, pcF;
    logic [DATA_WIDTH-1:0] RD1, RD2, ImmExt;
    logic [DATA_WIDTH-1:0] ALUResult, ReadData, Result;
    logic [DATA_WIDTH-1:0] WD3;

    logic RegWrite, MemWrite, ALUSrc, AddrMode;
    logic [1:0] ResultSrc;
    logic [3:0] ALUControl;
    logic Branch, Jump;         
    logic Zero, Negative;

    logic PCSrc;

    logic [DATA_WIDTH-1:0] a0_regfile;


    // ----------------------------
    // FETCH UNIT
    // ----------------------------
    fetch_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(ADDR_WIDTH)
    ) fetch_inst (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrc),
        .ALUResult(ALUResult),    // For JALR target
        .ImmExt(ImmExt),          // For JAL immediate
        .instr(instr),
        .PCPlus4(PCPlus4)
    );


    // ----------------------------
    // CONTROL UNIT
    // ----------------------------
    control control_inst (
        .op(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[30]),
        .Zero(Zero),
        .Negative(Negative),

        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ResultSrc(ResultSrc),
        .Branch(Branch),      // << explicit branch
        .Jump(Jump),          // << explicit jump
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .AddrMode(AddrMode)
    );


    // ----------------------------
    // REGISTER FILE
    // ----------------------------
    regfile regfile_inst (
        .clk(clk),
        .AD1(instr[19:15]),
        .AD2(instr[24:20]),
        .AD3(instr[11:7]),
        .WE3(RegWrite),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2),
        .a0(a0_regfile)
    );
    assign a0 = a0_regfile;

    immext immext_inst (
        .instr(instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    alu #(.DATA_WIDTH(DATA_WIDTH)) alu_inst (
        .SrcA(RD1),
        .SrcB(ALUSrc ? ImmExt : RD2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .Negative(Negative)
    );

    datamem #(.WIDTH(DATA_WIDTH)) datamem_inst (
        .clk(clk),
        .aluresult(ALUResult),
        .RD2(RD2),
        .MemWrite(MemWrite),
        .AddrMode(AddrMode),
        .RD(ReadData)
    );

    always_comb begin
        case (ResultSrc)
            2'b00: Result = ALUResult;
            2'b01: Result = ReadData;
            2'b10: Result = PCPlus4;   // JAL/JALR write PC+4
            2'b11: Result = ImmExt;    // LUI
            default: Result = ALUResult;
        endcase
    end

    assign WD3 = Result;
    assign PCSrc = Jump | (Branch & Zero);

endmodule