module hazard_unit #(
    parameter DATA_WIDTH = 32
)(
    input  logic [4:0] Rs1E, Rs2E, RdE,
    input  logic [4:0] Rs1D, Rs2D,
    input  logic RegWriteM, RegWriteW,
    input  logic [4:0] RdW, RdM,
    input  logic [1:0] ResultSrcE,
    input logic PCSrcE,
    output logic [1:0] ForwardAE, ForwardBE,
    output logic StallD, StallF, FlushE, FlushD
);
    logic lwStall;

    always_comb begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;

        if ((Rs1E != 0) && RegWriteM && (Rs1E == RdM)) begin
            ForwardAE = 2'b10;   // from MEM
        end 
        else if ((Rs1E != 0) && RegWriteW && (Rs1E == RdW)) begin
            ForwardAE = 2'b01;   // from WB
        end

        
        if ((Rs2E != 0) && RegWriteM && (Rs2E == RdM)) begin
            ForwardBE = 2'b10;   // from MEM
        end 
        else if ((Rs2E != 0) && RegWriteW && (Rs2E == RdW)) begin
            ForwardBE = 2'b01;   // from WB
        end
    end

    // if either source reg in decode stage == destination in exec and instruction is a lw, then stall
    always_comb begin
        if (ResultSrcE == 2'b01 && ((Rs1D == RdE) || (Rs2D == RdE))) begin
            lwStall = 1'b1;
        end        
        else begin
            lwStall = 1'b0;
        end
    end

    logic branchStall;

always_comb begin
    branchStall = 1'b0;

    // EX stage hazard
    if (BranchD && RegWriteE && ((RdE == Rs1D) || (RdE == Rs2D))) begin
        branchStall = 1'b1;
    end
    // MEM stage hazard (load that hasn’t written back)
    else if (BranchD && (ResultSrcM == 2'b01) && ((RdM == Rs1D) || (RdM == Rs2D))) begin
        branchStall = 1'b1;
    end
end

assign StallF = lwStall | branchStall;
assign StallD = lwStall | branchStall;
assign FlushE = lwStall | branchStall | PCSrcE;
assign FlushD = PCSrcE;

endmodule
