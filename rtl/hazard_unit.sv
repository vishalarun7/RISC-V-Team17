module hazard_unit #(
    parameter DATA_WIDTH = 32;
)(
    input logic     [4:0] Rs1E, Rs2E, //two source registers for instr in exec stage
    input logic     RegWriteM, RegWriteW, //to know if destination regs will actually be written to
    input logic     [4:0] RdW, RdM,  //destination reg addresses from instructions in Mem and WB stage
    input logic     [1:0] ResultSrc,
    output logic    [1:0] ForwardAE, ForwardBE, 
    output StallD, StallF, FlushE
);
    logic lwStall; 
    logic [DATA_WIDTH-1:0] ResultW; //WB result
    logic [DATA_WIDTH-1:0] ALUResultM; //from Mem


//It should forward from a stage if that stage will write a destination register and the destination register matches the source register.
always_comb begin
        // Default
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

//stalling a stage is performed by disabling the pipeline register, so that the contents do not change
if (ResultSrcE = 2'b01 && ((Rs1D == RdE) || (Rs2D == RdE))) begin
        lwStall = 1'b1;
    end        
    else begin
        lwStall = 1'b0;
    end

    StallF = StallD = FlushE = lwStall;
endmodule