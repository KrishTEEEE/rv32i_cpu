module mux#(parameter INPUT_WIDTH = 32)
(
    input logic [INPUT_WIDTH-1:0]       in_0,
    input logic [INPUT_WIDTH-1:0]       in_1,
    input logic                         sel,
    output logic                        mux_out
);

    assign mux_out = sel ? in_1 : in_0;
endmodule