module alu(
    input logic [31:0]      alu_op1,
    input logic [31:0]      alu_op2,
    input logic [3:0]       alu_control,
    output logic [31:0]     alu_out);

    // Input: alu_control mapping (between alu_decode and alu)
    localparam ADD = 4'd0;
    localparam SUB = 4'd1;
    localparam AND = 4'd2;
    localparam OR = 4'd3;
    localparam XOR = 4'd4;
    localparam SLT = 4'd5; //set less than signed
    localparam SLTU = 4'd6; //set less than unsigned
    localparam SLL = 4'd7; //shift left logical
    localparam SRL = 4'd8; //shift right logical
    localparam SRA = 4'd9; //shift right arithmetic



    // alu_op1 corresponds to rs1 (ins[19:15]), alu_op2 corresponds to rs2 (ins[24:20])
    always_comb begin
        case(alu_control)
            ADD: alu_out = alu_op1 + alu_op2;
            SUB: alu_out = alu_op1 - alu_op2;
            AND: alu_out = alu_op1 & alu_op2;
            OR: alu_out = alu_op1 | alu_op2;
            // 3'd4:;
            SLT: alu_out = alu_op1[31]&~alu_op2[31] | ~(alu_op1[31]^alu_op2[31])&(alu_op1[30:0] < alu_op2[30:0]);
            //signed set less than, implemented in explicit logic
            //instead of subtraction due to complications with overflow
            // 3'd6:;
            // 3'd7:;  
            default: alu_out = 32'b0;
        endcase
    end
endmodule
