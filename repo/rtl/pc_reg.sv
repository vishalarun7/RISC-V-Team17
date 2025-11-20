module pc_reg #(
    parameter WIDTH = 32
)(
    input logic [WIDTH-1:0] next_PC;
    input logic clk;
    input logic rst;
    output logic [WIDTH-1:0] PC;
);

always_ff @(posedge clk) begin
    if (rst) begin
        PC <= {WIDTH{1'b0}};
    end 
    else begin
        PC <= next_PC;
    end 
end
endmodule
