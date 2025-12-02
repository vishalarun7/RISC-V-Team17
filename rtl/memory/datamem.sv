module datamem #(
    parameter WIDTH = 32
)(
    input logic [WIDTH-1:0] aluresult,
    input logic [WIDTH-1:0] RD2,
    input logic clk, 
    input logic MemWrite,
    input logic AddrMode,
    output logic [WIDTH-1:0] RD
);

    logic [WIDTH-1:0] ram_array [32'h00001000:32'h0001FFFF];
    logic [WIDTH-3:0] word_index;
    logic [1:0] byte_offset;

    assign word_index  = aluresult[31:2]; //discard bottom two bits for word index
    assign byte_offset = aluresult[1:0]; 

    always_ff @(posedge clk) begin
        if (MemWrite) begin
            if (AddrMode == 1'b0) begin 
                ram_array[word_index] <= RD2; //sw
            end else begin
                case (byte_offset) //sb
                    2'b00: ram_array[word_index][7:0]   <= RD2[7:0];
                    2'b01: ram_array[word_index][15:8]  <= RD2[7:0];
                    2'b10: ram_array[word_index][23:16] <= RD2[7:0];
                    2'b11: ram_array[word_index][31:24] <= RD2[7:0];
                endcase
            end
        end
    end

    always_comb begin
        if (AddrMode == 1'b0) begin
            RD = ram_array[word_index]; //lw
        end else begin
            case (byte_offset) //lbu
                2'b00: RD = {24'h0, ram_array[word_index][7:0]};
                2'b01: RD = {24'h0, ram_array[word_index][15:8]};
                2'b10: RD = {24'h0, ram_array[word_index][23:16]};
                2'b11: RD = {24'h0, ram_array[word_index][31:24]};
            endcase
        end
    end

endmodule
