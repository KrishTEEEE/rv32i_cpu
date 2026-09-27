module alu_decode(
    input logic             opcode_5,
    input logic             funct7_5,
    input logic [2:0]       funct3,
    input logic [1:0]       alu_op,
    output logic [2:0]      alu_control
);
    // Local parameters that name the control signal values based on the operation it maps to
    // For easier debugging and extension of the processor
    localparam ADD = 3'd0;
    localparam SUB = 3'd1;
    localparam AND = 3'd2;
    localparam OR = 3'd3;
    localparam SLT = 3'd5; //set less than signed

    always_comb begin
        case(alu_op)
            2'b00: alu_control = 3'b0;
            2'b01: alu_control = 3'b001;
            2'b10: casez({funct3, opcode_5, funct7_5})
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