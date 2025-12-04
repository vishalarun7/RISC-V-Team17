module memory_writeback#(
    parameter DATA_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  RegWriteM,
    input  logic [1:0]            ResultSrcM,
    input  logic [4:0]            RdM,
    
    input  logic [DATA_WIDTH-1:0] ALUResultM,
    input  logic [DATA_WIDTH-1:0] ReadDataM,
    input  logic [DATA_WIDTH-1:0] PCPlus4M,
    
    output logic                  RegWriteW,
    output logic [1:0]            ResultSrcW,
    output logic [4:0]            RdW,
    output logic [DATA_WIDTH-1:0] ALUResultW,
    output logic [DATA_WIDTH-1:0] ReadDataW,
    output logic [DATA_WIDTH-1:0] PCPlus4W
);

    always_ff @(posedge clk) begin
        RegWriteW  <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        RdW        <= RdM;
        ALUResultW <= ALUResultM;
        ReadDataW  <= ReadDataM;
        PCPlus4W   <= PCPlus4M;
    end

endmodule
