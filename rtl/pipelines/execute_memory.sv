module execute_memory#(
    parameter DATA_WIDTH = 32
)(
    input logic clk,

    input logic RegWriteE,
    input logic MemWriteE, 
    input logic MemReadE, 
    input logic [1:0] ResultSrcE,
    input logic [4:0] RdE,
    input logic [DATA_WIDTH-1:0] PCPlus4E,
    input logic [DATA_WIDTH-1:0] ALUResultE,
    input logic [DATA_WIDTH-1:0] WriteDataE,
    input logic AddrModeE,

    output logic RegWriteM,
    output logic MemWriteM, 
    output logic MemReadM, 
    output logic [1:0] ResultSrcM,
    output logic [4:0] RdM,
    output logic [DATA_WIDTH-1:0] ALUResultM,
    output logic [DATA_WIDTH-1:0] WriteDataM,
    output logic [DATA_WIDTH-1:0] PCPlus4M,
    output logic AddrModeM
);
    
always_ff @(posedge clk) begin
        ALUResultM <= ALUResultE;            
        WriteDataM <= WriteDataE;            
        PCPlus4M <= PCPlus4E;                      
        MemWriteM <= MemWriteE;              
        MemReadM <= MemReadE;                
        RdM <= RdE;
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        AddrModeM <= AddrModeE;
    end
 
endmodule