module decode_top(
  parameter WIDTH = 32;
)(
    input logic [WIDTH-1:0] instr,
    input logic Zero, 
    input logic Negative, 
    output logic [WIDTH-1:0] RD1,
    output logic [WIDTH-1:0] RD2, 
    output logic [3:0] ALUControl
    output logic ResultSrc,
    output logic ALUSrc,
    output logic PCSrc, 
    output logic AddrMode,
    output logic [WIDTH-1:0] ImmExt,
);
(
)
module ImmExt(
  .instr(instr),
  .Imm ()
)
module control(
  .ImmSrc()
)
module regfile(
  .clk(clk),
  .WD3(Result),
  .A1(instr[19:15]),
  .A2(instr[24:20]),
  .A3(instr[11:7]),
  .RD1(),
  .RD2(),
)
