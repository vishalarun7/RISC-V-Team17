module pc_reg #(
    parameter WIDTH = 32
)(
    input logic [WIDTH-1:0] PCnext,
    input logic clk,
    input logic rst,
    input logic StallF,
    output logic [WIDTH-1:0] PC
);

always_ff @(posedge clk) begin
    if (rst) 
        PC <= {WIDTH{1'b0}}; 
    if (StallF)
        PC<=PC;
    else 
        PC <= PCnext; 
end

endmodule