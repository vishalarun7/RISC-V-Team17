// 00:I, 01:S, 10:B
module immext(
  input  logic [31:0] instr,
  input  logic [2:0]  ImmSrc,        
  output logic [31:0] ImmExt
);
  logic [11:0] immI, immS;
  logic [12:0] immB;
  logic [20:0] immJ;
  logic [19:0] immU;

  always_comb begin
    immI = instr[31:20];                           // I-type
    immS = {instr[31:25], instr[11:7]};            // S-type
    immB = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
    immU = instr[31:12];                           // U-Type
    immJ = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type

    case (ImmSrc)
      3'b000: ImmExt = {{20{immI[11]}}, immI}; //jalr, lw, imm ALU      
      3'b001: ImmExt = {{20{immS[11]}}, immS}; //sw         
      3'b010: ImmExt = {{19{immB[12]}}, immB}; //branches
      3'b011: ImmExt = {{11{immJ[20]}}, immJ}; //jal
      3'b100: ImmExt = {immU, 12'b0};          //lui, auipc
      default: ImmExt = 32'hDEADBEEF;                  
    endcase
  end
endmodule
