// 00:I, 01:S, 10:B
module ImmExt(
  input  logic [31:0] instr,
  input  logic [1:0]  ImmSrc,        
  output logic [31:0] ImmExt
);
  logic [11:0] immI, immS;
  logic [12:0] immB;

  always_comb begin
    immI = instr[31:20];                           // I-type
    immS = {instr[31:25], instr[11:7]};            // S-type
    immB = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type

    case (ImmSrc)
      2'b00: ImmExt = {{20{immI[11]}}, immI};          
      2'b01: ImmExt = {{20{immS[11]}}, immS};          
      2'b10: ImmExt = {{19{immB[12]}}, immB};          
      default: ImmExt = 32'hDEADBEEF;                  
    endcase
  end
endmodule
