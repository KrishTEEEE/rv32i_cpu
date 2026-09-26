module reg_file(
    input logic             clk,
    input logic [4:0]       rs1,
    input logic [4:0]       rs2,
    input logic [4:0]       rd,
    input logic [31:0]      din,
    input logic             wr_en,
    output logic [31:0]     rs1_out,
    output logic [31:0]     rs2_out
);

    logic [31:0] reg_f [31:0];

    assign rs1_out = (rs1 == 5'd0) ? 32'b0 : reg_f[rs1];
    // necessary to specify x0 read output
    // If continuously assigned reg_f[0] to 0, that and the non-blocking assignment in
    // the always_ff block gives a multiple driver error, even if physical correct
    assign rs2_out = (rs2 == 5'd0) ? 32'b0 : reg_f[rs2];

    always_ff@(posedge clk)
        if(wr_en && rd) reg_f[rd] <= din; //writes if wr_en is high AND destination register is not 0

endmodule