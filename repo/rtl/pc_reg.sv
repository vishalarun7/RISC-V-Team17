module pc_reg #(
    parameter ADDRESS_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0]  next_pc,
    input logic                      clk,
    input logic                      rst,
    output logic [ADDRESS_WIDTH-1:0] pc       
);

always_ff @(posedge clk) 
    if (rst) pc <= {ADDRESS_WIDTH{1'b0}};
    else pc <= next_pc;
endmodule
