module control(
  input  logic [31:0] instr,
  input  logic        Zero,         
  output logic        RegWrite,
  output logic        MemWrite,
  output logic        ALUSrc,
  output logic        ResultSrc,
  output logic        Branch,
  output logic [1:0]  ImmSrc,
  output logic [1:0]  ALUOp,
  output logic [2:0]  ALUControl,
  output logic        PCSrc
);
    //extract op,func3 and 7 from instr
  logic [6:0] op      = instr[6:0];
  logic [2:0] funct3  = instr[14:12];
  logic       funct7_5= instr[30];

  localparam OPC_LW   = 7'b0000011;
  localparam OPC_SW   = 7'b0100011;
  localparam OPC_R    = 7'b0110011;
  localparam OPC_BEQ  = 7'b1100011;

  //Main decoder
  always_comb begin
    RegWrite  = 1'b0;
    MemWrite  = 1'b0;
    ALUSrc    = 1'b0;
    ResultSrc = 1'b0;
    Branch    = 1'b0;
    ImmSrc    = 2'b00;
    ALUOp     = 2'b00;

    case (op)
      OPC_LW: begin
        RegWrite  = 1'b1;
        MemWrite  = 1'b0;
        ALUSrc    = 1'b1;      // use immediate offset
        ResultSrc = 1'b1;      // write back from data memory
        Branch    = 1'b0;
        ImmSrc    = 2'b00;     // I-type 
        ALUOp     = 2'b00;     // add for address calc
      end

      OPC_SW: begin
        RegWrite  = 1'b0;
        MemWrite  = 1'b1;
        ALUSrc    = 1'b1;
        ResultSrc = 1'b0;      // x
        Branch    = 1'b0;
        ImmSrc    = 2'b01;     // S-type 
        ALUOp     = 2'b00;    
      end

      OPC_R: begin
        RegWrite  = 1'b1;
        MemWrite  = 1'b0;
        ALUSrc    = 1'b0;      // use RD2 as B input
        ResultSrc = 1'b0;      // write back ALU result
        Branch    = 1'b0;
        ImmSrc    = 2'b00;     // x
        ALUOp     = 2'b10;     // decode by funct3/funct7
      end

      OPC_BEQ: begin
        RegWrite  = 1'b0;
        MemWrite  = 1'b0;
        ALUSrc    = 1'b0;      // compare RD1 and RD2
        ResultSrc = 1'b0;      // x
        Branch    = 1'b1;
        ImmSrc    = 2'b10;     // B-type 
        ALUOp     = 2'b01;     // subtract for comparison
      end

      default: begin
      end
    endcase
  end

    //Alu Decoder
  always_comb begin
  unique case (ALUOp)
    2'b00: ALUControl = 3'b000;                       // lw, sw 
    2'b01: ALUControl = 3'b001;                       // beq 
    2'b10: begin                                      // R-type 
      unique case (funct3)
        3'b000: begin
          ALUControl = ((op[5] & funct7_5) ? 3'b001 : 3'b000); // 11 => sub, else add
        end
        3'b010: ALUControl = 3'b101;                  // slt
        3'b110: ALUControl = 3'b011;                  // or
        3'b111: ALUControl = 3'b010;                  // and
        default: ALUControl = 3'b000; 
      endcase
    end
    default: ALUControl = 3'b000;
  endcase
end

  assign PCSrc = Branch & Zero; 
endmodule
