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
    if (rst) begin
        PC <= {WIDTH{1'b0}};
    end
    else if (!StallF) begin
        PC <= PCnext;
    end
end

endmodule
