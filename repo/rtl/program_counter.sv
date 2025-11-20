module program_counter #(
    parameter WIDTH = 32
)(
    input logic [WIDTH-1:0] ImmOP;
    input logic PCsrc;
    input logic clk;
    input logic rst;
    output logic [WIDTH-1:0] PC;
);

    logic [WIDTH-1:0] branch_PC;
    logic [WIDTH-1:0] next_PC;

assign branch_PC = ImmOP ^ PC;

pc_mux mux (
    .branch_PC (branch_PC)
    .inc_PC (PC + {WIDTH{3'b100}})
    .PCsrc (PCsrc)
    .next_PC (next_PC)
);

pc_reg reg (
    .next_PC (next_PC)
    .clk (clk)
    .rst (rst)
    .PC (PC)
);

endmodule