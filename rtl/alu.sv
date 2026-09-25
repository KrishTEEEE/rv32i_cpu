module alu(
    input logic [31:0]      alu_op1,
    input logic [31:0]      alu_op2,
    input logic [2:0]       alu_control,
    output logic [31:0]     alu_out);

    // alu_op1 corresponds to rs1 (ins[19:15]), alu_op2 corresponds to rs2 (ins[24:20])
    always_comb begin
        case(alu_control)
            3'd0: alu_out = alu_op1 + alu_op2;
            3'd1: alu_out = alu_op1 - alu_op2;
            3'd2: alu_out = alu_op1 & alu_op2;
            3'd3: alu_out = alu_op1 | alu_op2;
            // 3'd4:;
            3'd5: alu_out = {31'b0, alu_op1 < alu_op2}; // Unsigned!
            // 3'd6:;
            // 3'd7:;  
            default: alu_out = 32'b0;
        endcase
    end
endmodule
