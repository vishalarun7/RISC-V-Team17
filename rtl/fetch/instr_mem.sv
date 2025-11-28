module rom(
    parameter   ADDRESS_WIDTH = 32, 
                DATA_WIDTH = 8,
                OUT_WIDTH=32
)(
    input logic [ADDRESS_WIDTH-1:0] addr;
    output logic [DATA_WIDTH-1:0] instr;
);

logic [DATA_WIDTH-1:0] rom_array [32'h00000FFF:0]; //instructions from BFC00FFF to BFC0000

initial begin 
    $readmemh("program.mem", rom_array);
end;

always_comb begin
    instr = {rom_array[addr+3], rom_array[addr+2], rom_array[addr+1], rom_array[addr+0]}; // assemble 32-bit word from 4 bytes
end

endmodule