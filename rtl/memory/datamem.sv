module datamem #(
    parameter WIDTH = 32
)(
    input clk,

    input logic            mem_req,
    input logic            WriteEnable,
    input logic [31:0]     memory_address,
    input logic [127:0]    mem_writedata,
    output logic [127:0]   mem_readdata,
    output logic           mem_ready
    input clk,

    input logic            mem_req,
    input logic            WriteEnable,
    input logic [31:0]     memory_address,
    input logic [127:0]    mem_writedata,
    output logic [127:0]   mem_readdata,
    output logic           mem_ready
);

    logic [7:0] ram_array [32'h0001FFFF:0];

    //init data memory from data.hex file
    initial begin
        $readmemh("data.hex", ram_array, 32'h00010000);
    end

    // store
    // store
    always_ff @(posedge clk) begin
        mem_ready <= 0;
        if (mem_req && WriteEnable) begin
            ram_array[memory_address+15] <= mem_writedata[7:0];
            ram_array[memory_address+14] <= mem_writedata[15:8];
            ram_array[memory_address+13] <= mem_writedata[23:16];
            ram_array[memory_address+12] <= mem_writedata[31:24];
            ram_array[memory_address+11] <= mem_writedata[39:32];
            ram_array[memory_address+10] <= mem_writedata[47:40];
            ram_array[memory_address+9] <= mem_writedata[55:48];
            ram_array[memory_address+8] <= mem_writedata[63:56];
            ram_array[memory_address+7] <= mem_writedata[71:64];
            ram_array[memory_address+6] <= mem_writedata[79:72];
            ram_array[memory_address+5] <= mem_writedata[87:80];
            ram_array[memory_address+4] <= mem_writedata[95:88];
            ram_array[memory_address+3] <= mem_writedata[103:96];
            ram_array[memory_address+2] <= mem_writedata[111:104];
            ram_array[memory_address+1] <= mem_writedata[119:112];
            ram_array[memory_address] <= mem_writedata[127:120];

            mem_ready <= 1;
        end
        else if (mem_req && !WriteEnable) begin
            mem_readdata <= {ram_array[memory_address],
                            ram_array[memory_address+1],
                            ram_array[memory_address+2],
                            ram_array[memory_address+3],
                            ram_array[memory_address+4],
                            ram_array[memory_address+5],
                            ram_array[memory_address+6],
                            ram_array[memory_address+7],
                            ram_array[memory_address+8],
                            ram_array[memory_address+9],
                            ram_array[memory_address+10],
                            ram_array[memory_address+11],
                            ram_array[memory_address+12],
                            ram_array[memory_address+13],
                            ram_array[memory_address+14],
                            ram_array[memory_address+15]};
            mem_ready <= 1;
        mem_ready <= 0;
        if (mem_req && WriteEnable) begin
            ram_array[memory_address] <= mem_writedata[7:0];
            ram_array[memory_address+1] <= mem_writedata[15:8];
            ram_array[memory_address+2] <= mem_writedata[23:16];
            ram_array[memory_address+3] <= mem_writedata[31:24];
            ram_array[memory_address+4] <= mem_writedata[39:32];
            ram_array[memory_address+5] <= mem_writedata[47:40];
            ram_array[memory_address+6] <= mem_writedata[55:48];
            ram_array[memory_address+7] <= mem_writedata[63:56];
            ram_array[memory_address+8] <= mem_writedata[71:64];
            ram_array[memory_address+9] <= mem_writedata[79:72];
            ram_array[memory_address+10] <= mem_writedata[87:80];
            ram_array[memory_address+11] <= mem_writedata[95:88];
            ram_array[memory_address+12] <= mem_writedata[103:96];
            ram_array[memory_address+13] <= mem_writedata[111:104];
            ram_array[memory_address+14] <= mem_writedata[119:112];
            ram_array[memory_address+15] <= mem_writedata[127:120];

            mem_ready <= 1;
        end
        else if (mem_req && !WriteEnable) begin
            mem_readdata <= {ram_array[memory_address],
                            ram_array[memory_address+1],
                            ram_array[memory_address+2],
                            ram_array[memory_address+3],
                            ram_array[memory_address+4],
                            ram_array[memory_address+5],
                            ram_array[memory_address+6],
                            ram_array[memory_address+7],
                            ram_array[memory_address+8],
                            ram_array[memory_address+9],
                            ram_array[memory_address+10],
                            ram_array[memory_address+11],
                            ram_array[memory_address+12],
                            ram_array[memory_address+13],
                            ram_array[memory_address+14],
                            ram_array[memory_address+15]};
            mem_ready <= 1;
        end
    end

endmodule
