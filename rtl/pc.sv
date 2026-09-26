module pc(
    input logic clk, // clock
    input logic pc_src, //pc_src selects +4 or branch offset increment
    input logic rst, // reset
    input logic en, // enable
    input logic [31:0] imm, // sign-extended immediate
    output logic [31:0] pc_val // address truncation is handled on the ins_mem side
    // so that ins_mem size can be tuned
);
    
    always_ff @(posedge clk)
        if(rst) pc_val <= 32'b0;
        else if (en) begin
            case(pc_src)
                1'b0: pc_val <= pc_val + 32'd4;
                1'b1: pc_val <= pc_val + imm;
                default: pc_val <= pc_val + 32'd4;
            endcase
        end
endmodule