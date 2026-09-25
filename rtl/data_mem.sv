module data_mem #(parameter ADDRESS_WIDTH = 6 // 32 is too large for verilator modelling
)(
    input logic             clk, // clock
    input logic [31:0]      rd_addr, // read address
    input logic [31:0]      wr_addr, // write address
    input logic             wr_en, // write enable
    input logic [31:0]      din, // data input for write
    output logic [31:0]     dout); // data output for read

    logic [31:0] mem [2**ADDRESS_WIDTH-1: 0]; // NB: ADDRESS_WIDTH -1 is incorrect!

    // We are building a single-cycle processor, so all reads are asynchronous
    assign dout = mem[rd_addr[ADDRESS_WIDTH-1:0]];

    always_ff @(posedge clk) begin
        if(wr_en) mem[wr_addr[ADDRESS_WIDTH-1:0]] <= din;
    end
endmodule
