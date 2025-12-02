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

    logic [7:0] ram_array [32'h0001FFFF:0];
    logic [WIDTH-1:0] word_address;

    //init data memory from data.hex file
    initial begin
        $readmemh("data.hex", ram_array, 32'h00010000);
    end

    assign word_address = {aluresult[31:2], 2'b00}; //word-aligned address

    always_ff @(posedge clk) begin
        if (MemWrite) begin
            if (AddrMode == 1'b0) begin 
                // sw - write 4 bytes (little-endian)
                ram_array[word_address]     <= RD2[7:0];
                ram_array[word_address + 1] <= RD2[15:8];
                ram_array[word_address + 2] <= RD2[23:16];
                ram_array[word_address + 3] <= RD2[31:24];
            end else begin
                // sb - write 1 byte at exact address
                ram_array[aluresult] <= RD2[7:0];
            end
        end
    end

    always_comb begin
        if (AddrMode == 1'b0) begin
            // lw - read 4 bytes (little-endian)
            RD = {ram_array[word_address + 3], 
                  ram_array[word_address + 2], 
                  ram_array[word_address + 1], 
                  ram_array[word_address]};
        end else begin
            // lbu - read 1 byte at exact address
            RD = {24'h0, ram_array[aluresult]};
        end
    end

endmodule
