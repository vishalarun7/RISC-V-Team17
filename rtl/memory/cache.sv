module cache #(
    parameter WIDTH = 32,
    parameter ways = 2,
    parameter sets = 128,
    parameter block_size = 4,
    parameter v = 151,
    parameter u = 150,
    parameter d = 149,
    parameter t = 148,
    parameter t_ = 128
)(

    // cache-cpu
    input logic clk,
    input logic rst,
    input logic [WIDTH-1:0] data_address,
    input logic [WIDTH-1:0] write_data,
    input logic             MemWrite, // 1 store, 0 load
    input logic             AddrMode, // 1 byte, 0 word
    output logic [31:0]     read_data,
    output logic            stall,

    //cache-memory
    output logic            mem_req,
    output logic            WriteEnable,
    output logic [31:0]     memory_address,
    output logic [127:0]    mem_writedata,
    input  logic [127:0]    mem_readdata,
    input  logic            mem_ready
);

    //address decode

    logic [20:0] tag;
    logic [6:0] set;
    logic [1:0] block_offset;
    logic [1:0] byte_offset;

    assign tag = data_address[31:11];
    assign set = data_address[10:4];
    assign block_offset = data_address[3:2];
    assign byte_offset = data_address[1:0];

    //cache bit division

    logic [151:0] cache [ways-1:0][sets-1:0];

    logic v0, v1;
    logic u0, u1;
    logic d0, d1;
    logic [20:0] tag0, tag1;

    assign v0 = cache[0][set][v];
    assign u0 = cache[0][set][u];
    assign d0 = cache[0][set][d];
    assign tag0 = cache[0][set][t:t_];

    assign v1 = cache[1][set][v];
    assign u1 = cache[1][set][u];
    assign d1 = cache[1][set][d];
    assign tag1 = cache[1][set][t:t_];

    logic [151:0] way0; 
    logic [151:0] way1;

        assign way0 = cache[0][set];
        assign way1 = cache[1][set]; 

    //fsm

    typedef enum logic [2:0] {
        IDLE,
        WRITE_BACK,
        READ_MEM
    } my_state;

    my_state state, next_state;

    always_comb begin
    next_state = state;

        case (state)
            IDLE: begin
                if (!hit) begin
                    stall = 1;
                    if (dirty) begin
                        next_state = WRITE_BACK;
                    end 
                    else
                        next_state = READ_MEM;
                end
            end

            WRITE_BACK: begin
                if (mem_ready) begin
                    next_state = READ_MEM;
                end
            end

            READ_MEM: begin
                if (mem_ready) begin
                    next_state = IDLE;
                end

            end
        endcase
    end

    always_comb begin
        mem_req = 0;
        WriteEnable = 0;
        stall = 0;
        memory_address = 32'b0;
        mem_writedata = 128'b0;

        case(state)
            IDLE: begin
                mem_req = 0;
                WriteEnable = 0;
                stall = 0;
            end

            WRITE_BACK: begin
                stall = 1;
                mem_req = 1;
                WriteEnable = 1;
                memory_address = {cache[victim_reg][set][t:t_], set, 4'b0000}; //dirty victim tag
                mem_writedata = cache[victim_reg][set][127:0]; //dirty victim block
            end
            READ_MEM: begin
                stall = 1;
                mem_req = 1;
                WriteEnable = 0;
                memory_address = {tag, set, 4'b0000}; //requested address
            end
        endcase
    end




    //mux

    logic [31:0] mux0_out;
    mux4 data_0(
        .sel(block_offset),
        .in0(cache[0][set][31:0]),
        .in1(cache[0][set][63:32]),
        .in2(cache[0][set][95:64]),
        .in3(cache[0][set][127:96]),
        .out(mux0_out)
    );

    logic [31:0] mux1_out;
    mux4 data_1(
        .sel(block_offset),
        .in0(cache[1][set][31:0]),
        .in1(cache[1][set][63:32]),
        .in2(cache[1][set][95:64]),
        .in3(cache[1][set][127:96]),
        .out(mux1_out)
    );

    logic [31:0] data_out;
    mux2 data(
        .sel(hit1),
        .in0(mux0_out),
        .in1(mux1_out),
        .out(data_out)
    );

    logic hit0;
    logic hit1;
    logic hit;
    logic victim;
    logic dirty;


    // load value
    always_comb begin

        hit0 = v0 && (tag == tag0);
        hit1 = v1 && (tag == tag1);
        hit = hit0 || hit1;

        if (u0 == u1) begin
            victim = 0;
        end
        else begin
            victim = (u0 ? 1 : 0);
        end
        
        dirty = victim ? d1 : d0;

    end

    logic victim_reg;

    always_ff @(posedge clk or posedge rst) begin
        //========= hit handling =============
        if (rst) begin
            victim_reg <= 0;
            state <= IDLE;
            for (int i = 0; i < ways; i++) begin
                for (int j = 0; j < sets; j++) begin
                    cache[i][j] = 152'b0;
                end
            end
        end
        else begin
            state <= next_state;
        end

        if (hit && !MemWrite) begin //load
            if (AddrMode) begin  // Byte load
                read_data <= {24'b0, data_out[(byte_offset*8) +: 8]};
            end else begin  // Word load
                read_data <= data_out;
            end
            if (hit0) begin
                cache[0][set][u] <= 1;
                cache[1][set][u] <= 0;
            end
            else begin
                cache[1][set][u] <= 1;
                cache[0][set][u] <= 0;
            end
        end

        if (hit && MemWrite) begin //store
            if (hit0) begin
                cache[0][set][u] <= 1;
                cache[1][set][u] <= 0;
                cache[0][set][d] <= 1;
                if (!AddrMode) begin
                    cache[0][set][(block_offset*32) +: 32] <= write_data;
                end 
                else begin
                    cache[0][set][(block_offset*32)+(byte_offset*8) +: 8] <= write_data[7:0];
                end
            end
            else begin
                cache[1][set][u] <= 1;
                cache[0][set][u] <= 0;
                cache[1][set][d] <= 1;
                if (!AddrMode) begin
                    cache[1][set][(block_offset*32) +: 32] <= write_data;
                end else begin
                    cache[1][set][(block_offset*32)+(byte_offset*8) +: 8] <= write_data[7:0];
                end
            end
        end
        //============= miss hadnling ==========

        if (state == IDLE && !hit) begin
            victim_reg <= victim;
        end
        if (state == READ_MEM && mem_ready) begin
            cache[victim_reg][set][127:0] <= mem_readdata;
            cache[victim_reg][set][t:t_]   <= tag;
            cache[victim_reg][set][v]      <= 1;
            cache[victim_reg][set][d]      <= MemWrite;
            cache[victim_reg][set][u]      <= 1;
            cache[!victim_reg][set][u]     <= 0;
            if (MemWrite) begin
                if (!AddrMode) begin
                    cache[victim_reg][set][(block_offset*32) +: 32] <= write_data;
                end 
                else begin
                    cache[victim_reg][set][(block_offset*32)+(byte_offset*8) +: 8] <= write_data[7:0];
                end                
            end
            else begin  // Load miss - need to read the data we just fetched
                if (AddrMode) begin  // Byte load
                    read_data <= {24'b0, mem_readdata[(block_offset*32)+(byte_offset*8) +: 8]};
                end
                else begin  // Word load
                    read_data <= mem_readdata[(block_offset*32) +: 32];
                end
            end
        end
    end

    

endmodule
