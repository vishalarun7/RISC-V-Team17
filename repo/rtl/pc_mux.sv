module pc_mux #(
    parameter WIDTH = 32
)(
    input logic [WIDTH-1:0] branch_PC;
    input logic [WIDTH-1:0] inc_PC;
    input logic PCsrc;
    output logic [WIDTH-1:0] next_PC;
);

initial begin
    if (PCsrc) begin
        next_PC <= branch_PC;
    end
    else begin
        next_PC <= inc_PC;
    end
end
endmodule
    