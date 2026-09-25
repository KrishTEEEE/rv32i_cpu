module alu(
    input logic [31:0]      alu_op1,
    input logic [31:0]      alu_op2,
    input logic [2:0]       alu_control,
    output logic [31:0]     alu_out);

    // Local parameters that name the control signal values based on the operation it maps to
    // For easier debugging and extension of the processor
    localparam ADD = 3'd0;
    localparam SUB = 3'd1;
    localparam AND = 3'd2;
    localparam OR = 3'd3;
    localparam SLTU = 3'd5; //set less than unsigned

    // alu_op1 corresponds to rs1 (ins[19:15]), alu_op2 corresponds to rs2 (ins[24:20])
    always_comb begin
        case(alu_control)
            ADD: alu_out = alu_op1 + alu_op2;
            SUB: alu_out = alu_op1 - alu_op2;
            AND: alu_out = alu_op1 & alu_op2;
            OR: alu_out = alu_op1 | alu_op2;
            // 3'd4:;
            SLTU: alu_out = {31'b0, alu_op1 < alu_op2}; // Unsigned!
            // 3'd6:;
            // 3'd7:;  
            default: alu_out = 32'b0;
        endcase
    end
endmodule
