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
            // funct3 is roughly the same between I-type arithemetic and R-type ins
            // opcode[5] = 1 -> R-type; opcode[5] = 0 -> I-type
            // funct7[5] is used to differentiate R-type ADD, SUB; R-type SRL, SRA; I-type SRLI, SRAI;
            // opcode[5] is necessary for us to know when funct7[5] exists
                    5'b0000z: alu_control = ADD;
                    5'b00010: alu_control = ADD;
                    5'b00011: alu_control = SUB;
                    5'b001zz: alu_control = SLL;
                    5'b010zz: alu_control = SLT;
                    5'b011zz: alu_control = SLTU;
                    5'b100zz: alu_control = XOR;
                    5'b101z0: alu_control = SRL;
                    5'b101z1: alu_control = SRA;
                    5'b110zz: alu_control = OR;
                    5'b111zz: alu_control = AND;
             endcase
        endcase
    end
endmodule
