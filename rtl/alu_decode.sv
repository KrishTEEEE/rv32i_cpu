module alu_decode(
    input logic             opcode_5,
    input logic             funct7_5,
    input logic [2:0]       funct3,
    input logic [1:0]       alu_op,
    output logic [3:0]      alu_control
);
    // Input: alu_op mapping (between main_decode and alu_decode)
    localparam ALU_MEM = 2'b0;
    localparam ALU_ARITH = 2'b10;
    localparam ALU_BRANCH = 2'b01;

    // Output: alu_control mapping (between alu_decode and alu)
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

    always_comb begin
        case(alu_op)
            ALU_MEM: alu_control = ADD;
            ALU_BRANCH: alu_control = SUB;
            ALU_ARITH: casez({funct3, opcode_5, funct7_5})
                    5'b00000: alu_control = ADD;
                    5'b00001: alu_control = ADD;
                    5'b00010: alu_control = ADD;
                    5'b00011: alu_control = SUB;
                    5'b010zz: alu_control = SLT;
                    5'b110zz: alu_control = OR;
                    5'b111zz: alu_control = AND;
             endcase
        endcase
    end
endmodule
