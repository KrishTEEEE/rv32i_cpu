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
                3'b0: if(!alu_out) pc_src = 1'b1; else pc_src = 1'b0; //beq
                3'b1: if(alu_out) pc_src = 1'b1; else pc_src = 1'b0; //bne
                3'b100: if(alu_out) pc_src = 1'b1; else pc_src = 1'b0; //blt
                3'b101: if(!alu_out) pc_src = 1'b1; else pc_src = 1'b0; //bge
                3'b110: if(alu_out) pc_src = 1'b1; else pc_src = 1'b0; //bltu
                3'b111: if(!alu_out) pc_src = 1'b1; else pc_src = 1'b0; //bgeu
                default: pc_src = 1'b0;
            endcase
        end
    end
endmodule
