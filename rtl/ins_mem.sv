module ins_mem #(parameter ADDRESS_WIDTH = 8)
(
    input logic [31:0]          pc,
    output logic [31:0]         ins_out
);
    logic [31:0] rom_array [2**ADDRESS_WIDTH-1:0];
    assign ins_out = rom_array[pc[ADDRESS_WIDTH-1:0]];
endmodule