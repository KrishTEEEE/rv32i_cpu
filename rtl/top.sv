module top(
    input logic             clk,
    input logic             rst, //verify if this connected to pc.rst works
    output logic [31:0]     result
);
  
    // Fetch
    logic [31:0]        pc_out;
    logic [31:0]        ins_out;
    
    // Instruction fields
    logic [6:0]         opcode;
    logic [2:0]         funct3;
    logic [6:0]         funct7;
    logic [4:0]         rs1;
    logic [4:0]         rs2;
    logic [4:0]         rd;
    assign {funct7, rs2, rs1, funct3, rd, opcode} = ins_out;

    // Decoder signals
    logic               wr_reg; // write register
    logic [1:0]         imm_src; // immediate encoding format for sign extension
    logic               alu_src; // source of alu_op2, imm or rs2
    logic [1:0]         alu_op; // internal control unit signal to simplify alu decoding
    logic               wr_data_mem; // write to data memory
    logic               result_src; // source of operation result, data_mem or alu_out
    logic [2:0]         alu_control;

    // ImmExt
    logic [31:0]        imm_ext;

    // Register File
    logic [31:0]        rs1_out;
    logic [31:0]        rs2_out;

    // ALU
    logic [31:0]        alu_out;
    
    // Data Memory
    logic [31:0]        data_mem_out;

    // TODO: ADD PC_SRC and pc_val EN
    pc pc_val(.clk(clk), .pc_src(1'b0), .rst(rst), .en(1'b1), .imm_ext(imm_ext), .pc_val(pc_out));
    ins_mem ins_mem(.pc(pc_out), .ins_out(ins_out));
    main_decode m_decode(.opcode(opcode), .wr_reg(wr_reg), .imm_src(imm_src), .alu_src(alu_src), .alu_op(alu_op), .wr_data_mem(wr_data_mem), .result_src(result_src));
    alu_decode alu_decode(.opcode_5(opcode[5]), .funct7_5(funct7[5]), .funct3(funct3), .alu_op(alu_op), .alu_control(alu_control));
    reg_file reg_f(.clk(clk), .rs1(rs1), .rs2(rs2), .rd(rd), .din(result), .wr_en(wr_reg), .rs1_out(rs1_out), .rs2_out(rs2_out));
    extend imm_extend(.ins(ins_out), .imm_src(imm_src), .imm_ext(imm_ext));
    alu alu(.alu_op1(rs1_out), .alu_op2(rs2_out), .alu_control(alu_control), .alu_out(alu_out));
    data_mem data_mem(.clk(clk), .addr(alu_out), .wr_en(wr_data_mem), .din(rs2_out), .dout(data_mem_out));
    mux result_mux(.in_0(alu_out), .in_1(data_mem_out), .sel(result_src), .mux_out(result));

endmodule