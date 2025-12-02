module control(
  input  logic [6:0]  op,       // opcode
  input  logic [2:0]  funct3,
  input  logic        funct7,   // bit [30],
  input logic         Zero,     //flag for when two values are equal 
  input logic         Negative, //flag for when a value is negative   

  output logic        RegWrite, //enable for regfile
  output logic        MemWrite, //enable for datamem
  output logic        ALUSrc,   //select for SrcB to ALU
  output logic [1:0]  ResultSrc,//Result mux sel line; 00 = ALU result; 01 = Datamem; 10 = Pcplus4 (jal, jalr); 11 = Imm
  output logic        Branch,
  output logic        Jump, 
  output logic [2:0]  ImmSrc,     //Imm-type
  output logic [1:0]  PCSrc,     //pc mux sel line; 0 = pc+4 ; 1 = pc+imm (branch,jal); 2 = aluresult (jalr) ; 3 = pc (stall)
  output logic [3:0]  ALUControl,//controls the operation to be performed in ALU
  output logic        AddrMode   //byte (0) and word (1) addressing 
);

  task ALU_control(
      input   logic [6:0] op_code,
      input   logic [2:0] funct_3,
      input   logic       funct_7,
      output  logic [3:0] ALU_control
  );
      begin
          case (funct_3)
              3'd0: if (op_code == 7'b0010011) ALU_control = 4'b0000;
                    else   ALU_control = funct_7 ? 4'b0001 : 4'b0000; // add | addi (funct7 = 0) or sub (funct7 = 1)
              3'd1: ALU_control = 4'b0101; // sll | slli
              3'd2: ALU_control = 4'b1000; // slt | slti
              3'd3: ALU_control = 4'b1001; // sltu | sltiu
              3'd4: ALU_control = 4'b0100; // xor | xori
              3'd5: ALU_control = funct_7 ? 4'b0110 : 4'b0111; // srl | slri (funct7 = 0) or sra | srai (funct7 = 1)
              3'd6: ALU_control = 4'b0011; // or | ori
              3'd7: ALU_control = 4'b0010; // and | andi
              default: ALU_control = 4'b0000; // undefined
          endcase
      end
  endtask

  always_comb begin
    // defaults 
    RegWrite = 1'b0; 
    ImmSrc = 3'b000; 
    MemWrite = 1'b0; 
    ResultSrc = 2'b00; 
    PCSrc = 2'b00; 
    ALUSrc = 1'b0; 
    ALUControl = 4'b0000; 
    AddrMode = 1'b0;
    Branch = 1'b0;
    Jump = 1'b0;

    case (op)
        // R-type
        7'b0110011: begin 
            RegWrite = 1'b1; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'b00; PCSrc = 2'b00;
            ALU_control(op, funct3, funct7, ALUControl);
        end

        // I-type (ALU instructions)
        7'b0010011: begin 
            RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ResultSrc = 2'b00; ALUSrc = 1'b1; PCSrc = 2'b00; 
            ALU_control(op, funct3, funct7, ALUControl);
        end

        // I-type (loading)
        7'b0000011: begin
            RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b1; ALUControl = 4'b0000; ResultSrc = 2'b01; PCSrc = 2'b00;
            case (funct3)
                3'b010: AddrMode = 1'b0;     // LW
                3'b100: AddrMode = 1'b1;     // LBU
                default: AddrMode = 1'b0;
            endcase
        end

        // I-type (jalr)
        7'b1100111: begin
            RegWrite = 1'b1; MemWrite = 1'b0; ImmSrc = 3'b000; ResultSrc = 2'b10; PCSrc = 2'b10; ALUControl = 4'b0000; ALUSrc = 1'b1;
        end

        // S-type
        7'b0100011: begin 
            RegWrite = 1'b0; ImmSrc = 3'b001; ALUSrc = 1'b1; ALUControl = 4'b0000; MemWrite = 1'b1; PCSrc = 2'b00;
            case (funct3)
                3'b000: AddrMode = 1'b1;    // SB
                3'b010: AddrMode = 1'b0;    // SW
                default: AddrMode = 1'b0;
            endcase
        end

        // B-type
        7'b1100011: begin 
            RegWrite = 1'b0; ImmSrc = 3'b010; ALUSrc = 1'b0; ALUControl = 4'b0001; MemWrite = 1'b0;
            case (funct3)
                3'b000: PCSrc = Zero ? 2'b01 : 2'b00;          // beq
                3'b001: PCSrc = ~Zero ? 2'b01 : 2'b00;         // bne
                3'b100: PCSrc = Negative ? 2'b01 : 2'b00;      // blt 
                3'b101: PCSrc = ~Negative ? 2'b01 : 2'b00;     // bge
                3'b110: PCSrc = Negative ? 2'b01 : 2'b00;      // bltu
                3'b111: PCSrc = ~Negative ? 2'b01 : 2'b00;     // bgeu
                default: PCSrc = 2'b00;
            endcase
        end

        // U-type (lui)
        7'b0110111: begin 
            RegWrite = 1'b1; ImmSrc = 3'b100; MemWrite = 1'b0; ResultSrc = 2'b11; PCSrc = 2'b00;
        end

        // J-type (jal)
        7'b1101111: begin 
            RegWrite = 1'b1; ImmSrc = 3'b011; MemWrite = 1'b0; ResultSrc = 2'b10; PCSrc = 2'b01;
        end
    endcase
  end

endmodule
