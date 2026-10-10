module ins_mem #(parameter ADDRESS_WIDTH = 8)
(
    input logic [31:0]          pc,
    output logic [31:0]         ins_out
);
    logic [31:0] rom_array [2**ADDRESS_WIDTH-1:0];

    initial begin
        $display("Loading instruction memory...");
        $readmemh("ins_mem.mem", rom_array);
        $display("rom[0] = %h", rom_array[0]);
        $display("rom[1] = %h", rom_array[1]);
    end

    assign ins_out = rom_array[pc[ADDRESS_WIDTH+1:2]]; //effective pc bitwidth limitation in hardware?
endmodule
