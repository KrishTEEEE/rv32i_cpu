// function: sign extend an immediate to 32-bits from the instruction, extending
// following different ins formats based on imm_src control signal
module extend(input logic [31:7] ins, input logic [1:0] imm_src, output logic [31:0] imm_ext);
    always_comb begin
        case(imm_src)
        2'b0: imm_ext = {20{ins[31]}, ins[31:20]}; // I-type, includes imm arithmetic, logic, and load instructions
        2'b1: imm_ext = {20{ins[31]}, ins[31:25], ins[11:7]}; // S-type, storing values into data memory
        2'b10: imm_ext = {20{ins[31]}, ins[7], ins[30:25], ins[11:8], 1'b0}; // B-type, branching to control flow of program accessed via PC value
        // B-type follows S-type closely to reuse hardware for decoding logic
        // imm[12:1] is ordered as such: imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11]
        // Note the actual PC offset is a 13-bit number! -> {imm, 1'b0}
        default: imm_ext = 32'b0;
        endcase
    end
endmodule
