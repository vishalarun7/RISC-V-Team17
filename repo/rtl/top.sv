module top #(
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 32
) (
    input   logic                  clk,
    input   logic                  rst,
    output  logic [DATA_WIDTH-1:0] a0    
); 
    logic [ADDRESS_WIDTH-1:0] pc;
    logic                     pcsrc;
    logic [ADDRESS_WIDTH-1:0] next_pc;
    logic [ADDRESS_WIDTH-1:0] branch_pc;
    logic [ADDRESS_WIDTH-1:0] inc_pc;
    logic [DATA_WIDTH-1:0]    immop;


    assign a0 = 32'd5;

    assign branch_pc = pc + immop;
    assign inc_pc = pc + 4;

mux PC_MUX (
    .in0 (branch_pc),
    .in1 (inc_pc),
    .sel (pcsrc),
    .out (next_pc)
);

pc_reg PC_REG (
    .clk (clk),
    .rst (rst),
    .next_pc(next_pc),
    .pc (pc)
);

endmodule
