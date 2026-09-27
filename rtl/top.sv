module top(
    input logic             clk,
    input logic             rst, //verify if this connected to pc.rst works
    output logic [31:0]     result
);
    //PC


    // Decoder signals
    // TODO: ADD PC_SRC!
    logic [6:0]       opcode, // instruction opcode
    logic            wr_reg, // write register
    logic [1:0]      imm_src, // immediate encoding format for sign extension
    logic            alu_src, // source of alu_op2, imm or rs2
    logic [1:0]      alu_op, // internal control unit signal to simplify alu decoding
    logic            wr_data_mem, // write to data memory
    logic            result_src // source of operation result, data_mem or alu_out
    logic [2:0]      alu_control


    pc pc_val(.clk(clk), .pc_src(1'b0), .rst(rst), .en(1'b1), .imm_ext(), .pc_val());
    ins_mem ins_mem(.pc(), .ins_out());
    main_decode m_decode(.opcode(), .wr_reg(), .imm_src(), .alu_src(), .alu_op(), .wr_data_mem(), .result_src());
    alu_decode alu_decode(.opcode_5(), .funct7_5(), .funct3(), .alu_op(), .alu_control());
    reg_file reg_f(.clk(clk), .rs1(), .rs2(), .rd(), .din(), .wr_en(), .rs1_out(), .rs2_out());
    extend imm_extend(.ins(), .imm_src(), .imm_ext());
    alu alu(.alu_op1(), .alu_op2(), .alu_control(), .alu_out());
    data_mem data_mem(.clk(clk), .rd_addr(), .wr_addr(), .wr_en(), .din(), .dout());

endmodule