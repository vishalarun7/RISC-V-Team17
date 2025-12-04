module fetch_decode#(
    parameter DATA_WIDTH = 32;
)(
    input logic         clk, 
    input logic         FlushD, 
    input logic         StallD,

    input logic [DATA_WIDTH-1:0] PCPlus4F, instr;       
    input logic [DATA_WIDTH-1:0] pcF; 

    output logic [DATA_WIDTH-1:0] PCPlus4D, instrD;
    output logic [DATA_WIDTH-1:0] pcD;
);

alwaysff(@posedge clk) begin 
    if (!StallD) begin
        instrD <= instr;
        pcD <= pcF;
        PCPlus4D <= PCPlus4F;
    end

    if (FlushD) begin
        instrD <= 32'h00000013; //nop
    end
end
endmodule
