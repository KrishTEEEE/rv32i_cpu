module main_decode(
    input logic [6:0]       opcode, // instruction opcode
    output logic            wr_reg, // write register
    output logic [1:0]      imm_src, // immediate encoding format for sign extension
    output logic            alu_src, // source of alu_op2, imm or rs2
    output logic [1:0]      alu_op, // internal control unit signal to simplify alu decoding
    output logic            wr_data_mem, // write to data memory
    output logic            result_src // source of operation result, data_mem or alu_out

    //TODO: ADD PC_SRC!
);
    // opcode mapping
    localparam OP_R = 7'd51;
    localparam OP_L = 7'd3;
    localparam OP_I = 7'd19;
    localparam OP_S = 7'd35;
    localparam OP_B = 7'd99;

    // alu_op mapping
    localparam ALU_MEM = 2'b0;
    localparam ALU_ARITH = 2'b10;
    localparam ALU_BRANCH = 2'b01;

    always_comb begin
        //default
        imm_src = 2'b0;
        wr_reg = 1'b1;
        wr_data_mem = 1'b0; // only asserted when writing to data_mem
        result_src = 1'b0;

        case(opcode)
            OP_R: begin
                alu_src = 1'b0;
                result_src = 1'b0;
                alu_op = ALU_ARITH;
            end
            OP_L: begin
                alu_src = 1'b1;
                result_src = 1'b1;
                alu_op = ALU_MEM;
            end
            OP_I: begin
                alu_src = 1'b1;
                result_src = 1'b0;
                alu_op = ALU_ARITH;
            end
            OP_S: begin
                wr_reg = 1'b0;
                imm_src = 2'b01;
                alu_src = 1'b1;
                wr_data_mem = 1'b1; // S-type instructions write to data_mem
                alu_op = ALU_MEM;
            end
            OP_B: begin
                wr_reg = 1'b0;
                imm_src = 2'b10;
                alu_src = 1'b0;
                alu_op = ALU_BRANCH;
            end
        endcase
    end

endmodule