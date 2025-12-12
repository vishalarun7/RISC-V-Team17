module execute_memory#(
    parameter DATA_WIDTH = 32
)(
    input logic clk,

    input logic RegWriteE,
    input logic MemWriteE, 
    input logic [1:0] ResultSrcE,
    input logic [4:0] RdE,
    input logic [DATA_WIDTH-1:0] PCPlus4E,
    input logic [DATA_WIDTH-1:0] ALUResultE,
    input logic [DATA_WIDTH-1:0] WriteDataE,
    input logic AddrModeE,
    input logic [DATA_WIDTH-1:0] ImmExtE,
    input logic StallM,

    output logic RegWriteM,
    output logic MemWriteM, 
    output logic [1:0] ResultSrcM,
    output logic [4:0] RdM,
    output logic [DATA_WIDTH-1:0] ALUResultM,
    output logic [DATA_WIDTH-1:0] WriteDataM,
    output logic [DATA_WIDTH-1:0] PCPlus4M,
    output logic AddrModeM,
    output logic [DATA_WIDTH-1:0] ImmExtM
);
    
always_ff @(posedge clk) begin
    if (!StallM) begin
        ALUResultM <= ALUResultE;            
        WriteDataM <= WriteDataE;            
        PCPlus4M <= PCPlus4E;                      
        MemWriteM <= MemWriteE;              
        RdM <= RdE;
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        AddrModeM <= AddrModeE;
        ImmExtM <= ImmExtE;
    end
    end
 
endmodule
