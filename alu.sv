module alu(input[31:0] alu_op1, input[31:0] alu_op2, input [2:0] alu_control, output [31:0] alu_out);
    always_comb begin
        case(alu_control)
            3'd0: alu_out = alu_op1 + alu_op2;
            3'd1: alu_out = alu_op1 - alu_op2; //verify polarity against instruction!
            3'd2: alu_out = alu_op1 & alu_op2;
            3'd3: alu_out = alu_op1 | alu_op2;
            // 3'd4:;
            3'd5: alu_out = {31'b0, {alu_op1 < alu_op2}};
            // 3'd6:;
            // 3'd7:;  
            default: alu_out = 32'b0;
        endcase
    end
endmodule