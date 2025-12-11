module regfile #(
    parameter ADDRESS_WIDTH = 32
)(
    input logic clk,
    input logic [4:0]                AD1,
    input logic [4:0]                AD2,
    input logic [4:0]                AD3,
    input logic                      WE3,
    input logic [ADDRESS_WIDTH-1:0]  WD3,
    output logic [ADDRESS_WIDTH-1:0] RD1,
    output logic [ADDRESS_WIDTH-1:0] RD2,
    output logic [ADDRESS_WIDTH-1:0] a0
);
    logic [ADDRESS_WIDTH-1:0] register [31:0];

    assign a0  = register[10];
    assign RD1 = (AD1 == 0) ? 0 : register[AD1];
    assign RD2 = (AD2 == 0) ? 0 : register[AD2];

    always_ff @(negedge clk) begin //adjusted to write on negative edge of clock
        if (WE3 && AD3 != 5'd0) begin
            register[AD3] <= WD3;
        end
    end

endmodule
