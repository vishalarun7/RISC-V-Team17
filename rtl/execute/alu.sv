module alu #(
    parameter DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] SrcA,
    input logic [DATA_WIDTH-1:0] SrcB,
    input logic [3:0] ALUControl,
    output logic [DATA_WIDTH-1:0] ALUResult,
    output logic Zero
);

    always_comb begin
        case (ALUControl)
            4'b0000: ALUResult = SrcA + SrcB;                    // add
            4'b0001: ALUResult = SrcA - SrcB;                    // sub
            4'b0010: ALUResult = SrcA & SrcB;                    // and
            4'b0011: ALUResult = SrcA | SrcB;                    // or
            4'b0100: ALUResult = SrcA ^ SrcB;                    // xor
            4'b0101: ALUResult = SrcA << SrcB[4:0];              // sll
            4'b0110: ALUResult = SrcA >>> SrcB[4:0];             // sra
            4'b0111: ALUResult = SrcA >> SrcB[4:0];              // srl
            4'b1000: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;  // slt
            4'b1001: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0;  // sltu
            default: ALUResult = 32'd0;
        endcase
    end

    assign Zero = (ALUResult == 0);

endmodule
