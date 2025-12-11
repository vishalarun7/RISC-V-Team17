module decode_execute #(
    parameter DATA_WIDTH = 32
)(
    input  logic clk,
    input  logic FlushE,

    // control signals 
    input  logic AddrModeD,
    input  logic RegWriteD,
    input  logic MemWriteD,
    input  logic JumpD,
    input  logic BranchD,
    input  logic ALUSrcD,
    input  logic [1:0] ResultSrcD,
    input  logic [3:0] ALUControlD,

    // Data signals 
    input  logic [4:0] Rs1D, Rs2D, RdD,
    input  logic [DATA_WIDTH-1:0] RD1D, RD2D,
    input  logic [DATA_WIDTH-1:0] pcD, PCPlus4D, ImmExtD,

    // Control outputs 
    output logic AddrModeE,
    output logic RegWriteE,
    output logic MemWriteE,
    output logic JumpE,
    output logic BranchE,
    output logic ALUSrcE,
    output logic [1:0] ResultSrcE,
    output logic [3:0] ALUControlE,

    // data outputs 
    output logic [4:0] Rs1E, Rs2E, RdE,
    output logic [DATA_WIDTH-1:0] RD1E, RD2E,
    output logic [DATA_WIDTH-1:0] pcE, PCPlus4E, ImmExtE
);

always_ff @(posedge clk) begin

    if (FlushE) begin
        RegWriteE   <= 0;
        MemWriteE   <= 0;
        JumpE       <= 0;
        BranchE     <= 0;
        ALUSrcE     <= 0;
        ResultSrcE  <= 0;
        ALUControlE <= 0;
        AddrModeE   <= 0;
    end
    else begin
        //no flush then pass control signals as usual.
        RegWriteE   <= RegWriteD;
        MemWriteE   <= MemWriteD;
        JumpE       <= JumpD;
        BranchE     <= BranchD;
        ALUSrcE     <= ALUSrcD;
        ResultSrcE  <= ResultSrcD;
        ALUControlE <= ALUControlD;
        AddrModeE   <= AddrModeD;
    end

    //pass data
    Rs1E    <= Rs1D;
    Rs2E    <= Rs2D;
    RdE     <= RdD;
    RD1E    <= RD1D;
    RD2E    <= RD2D;
    pcE     <= pcD;
    PCPlus4E<= PCPlus4D;
    ImmExtE <= ImmExtD;

end

endmodule
