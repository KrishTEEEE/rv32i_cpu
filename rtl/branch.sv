module branch(
    input logic [2:0]       funct3,
    input logic [31:0]      alu_out, // current result is only alu_op1 - alu_op2
    input logic             opcode_6,
    output logic            pc_src
);
    always_comb begin
        if(!opcode_6) pc_src = 1'b0; // checks if this is a branch instruction
        else begin
            case(funct3)
                3'd0: if(!alu_out) pc_src = 1'b1; else pc_src = 1'b0; //beq
                3'd1: if(!alu_out) pc_src = 1'b0; else pc_src = 1'b1; //bne
                default: pc_src = 1'b0;
            endcase
        end
    end
endmodule
