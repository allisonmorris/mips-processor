
module DecodeModule (input clk, input reset, input [25:0] bundle_in, output [13:0] bundle_out,
		input [31:0] pc_seq_in, input [31:0] pc_seq_2_in, output [31:0] pc_seq_out, input [31:0] instr_in,
		output [31:0] operand_a_out, output [31:0] operand_b_out, output [31:0] reg_read2_out, 
		output [4:0] reg_write_dest_out, input [4:0] reg_write_dest_in, input [31:0] reg_write_data_in, output [31:0] jump_address_out);

	
	// input wires for after registers
	wire [4:0] reg_write_dest_2;
	wire [25:0] bundle;
	wire [31:0] instr, pc_seq, pc_seq_2, reg_write_data;
	
	// control wires
	wire [5:0] alu_func;
	wire [1:0] reg_write_dest_mux_sel;
	wire       alu_in_a_mux_sel,
				  alu_in_b_mux_sel,
				  skip_imm_upshift_mux_sel,
				  imm_signed_mux_sel,
				  jump_branch_mux_sel,
				  branch_mux_sel,
				  jump_mux_sel,
				  jump_imm_reg_mux_sel,  
				  reg_write_en,
				  reg_write_data_mux_sel;

	// instruction wires
	wire [25:0] instr_jump_imm;
	wire [15:0] instr_data_imm;
	wire [5:0]  instr_func,
	            instr_opcode;
	wire [4:0]  instr_rs,
					instr_rt,
					instr_rd,
					instr_shamt;
	
	// wires in between modules
	wire [31:0] reg_read1, reg_read2,
	            shamt_extended,
					jump_imm_extended,
					imm_signed_extended,
					imm_unsigned_extended,
					imm_signed,
					jump_branch,
					jump_imm_shifted,
					jump_imm_concatenated,
					data_imm_upshifted,
					skip_imm_upshift,
					pc_branch_sum,
					branch_address,
					jump_address,
					jump_imm_reg,
					reg_write_data_muxed,
					pc_writeback_sum;
	wire [4:0] reg_write_dest;

	
	// assign controls
	assign alu_func = bundle[13:8];
	assign reg_write_dest_mux_sel = bundle[15:14];
	assign alu_in_a_mux_sel = bundle[16];
	assign alu_in_b_mux_sel = bundle[17];
	assign skip_imm_upshift_mux_sel = bundle[18];
	assign imm_signed_mux_sel = bundle[19];
	assign jump_branch_mux_sel = bundle[20];
	// assign branch_mux_sel = bundle[21];
	assign jump_mux_sel = bundle[22];
	assign jump_imm_reg_mux_sel = bundle[23];
	assign reg_write_en = bundle[24];
	assign reg_write_data_mux_sel = bundle[25];
	
	// assign instruction wires
	assign instr_jump_imm = instr[25:0];
	assign instr_data_imm = instr[15:0];
	// assign instr_func = instr[5:0];
	// assign instr_opcode = instr[31:26];
	assign instr_rs = instr[25:21];
	assign instr_rt = instr[20:16];
	assign instr_rd = instr[15:11];
	assign instr_shamt = instr[10:6];
	
	// assign outputs
	assign reg_read2_out = reg_read2;
	assign reg_write_dest_out = reg_write_dest;
	assign pc_seq_out = pc_seq;
	assign bundle_out[13:0] = bundle[13:0];
	
	// registers
	register #(.W(26), .D(26'h00e2531)) controls (.clk(clk), .reset(reset), .enable(1'b1), .data_in(bundle_in), .q_out(bundle));	
	register #(.W(32)) pc (.clk(clk), .reset(reset), .enable(1'b1), .data_in(pc_seq_in), .q_out(pc_seq));
	register #(.W(32)) pc2 (.clk(clk), .reset(reset), .enable(1'b1), .data_in(pc_seq_2_in), .q_out(pc_seq_2));
	register #(.W(32), .D(32'h34000000)) instrReg (.clk(clk), .reset(reset), .enable(1'b1), .data_in(instr_in), .q_out(instr));
	register #(.W(32)) regWriteData (.clk(clk), .reset(reset), .enable(1'b1), .data_in(reg_write_data_in), .q_out(reg_write_data));
	register #(.W(5), .D(5'h00)) regWriteDest (.clk(clk), .reset(reset), .enable(1'b1), .data_in(reg_write_dest_in), .q_out(reg_write_dest_2));
	
	// modules
	
	fourInMux#(.W(5)) regWriteDestMux (.a_in(instr_rt), .b_in(instr_rd), 
		.c_in(5'b11111), .d_in(5'b00000), .mux_out(reg_write_dest), .select(reg_write_dest_mux_sel)); 
	
	// register file 
	regfile regs (.clk(clk), .reset(reset), .enable(reg_write_en), .readReg1_in(instr_rs), 
		.readReg2_in(instr_rt), .writeReg_in(reg_write_dest_2), 
		.writeData_in(reg_write_data_muxed), .data1_out(reg_read1), .data2_out(reg_read2));
	
	unsignExtend #(.W(5)) shamtExtender (.i_in(instr_shamt), .extend_out(shamt_extended));
	
	upShifter dataImmUpshifter (._in(instr_data_imm), ._out(data_imm_upshifted));
	
	twoInMux #(.W(32)) skipImmUpshiftMux(.a_in(data_imm_upshifted), .b_in(imm_signed), .select(skip_imm_upshift_mux_sel), 
		.mux_out(skip_imm_upshift));
	
	twoInMux #(.W(32)) operandAMux(.a_in(reg_read1), .b_in(shamt_extended), .select(alu_in_a_mux_sel), 
		.mux_out(operand_a_out));
		
	twoInMux #(.W(32)) operandBMux(.a_in(reg_read2), .b_in(skip_imm_upshift), .select(alu_in_b_mux_sel), 
		.mux_out(operand_b_out));
	
	unsignExtend #(.W(26)) jumpImmExtender (.i_in(instr_jump_imm), .extend_out(jump_imm_extended));
	
	unsignExtend #(.W(16)) immUnsignedExtender (.i_in(instr_data_imm), .extend_out(imm_unsigned_extended));
	
	signExtend #(.W(16)) immSignedExtender (.i_in(instr_data_imm), .extend_out(imm_signed_extended));
	
	twoInMux #(.W(32)) immSignedMux (.a_in(imm_signed_extended), .b_in(imm_unsigned_extended), .select(imm_signed_mux_sel), 
		.mux_out(imm_signed));
	
	twoInMux #(.W(32)) jumpBranchMux(.a_in(imm_signed), .b_in(jump_imm_extended), .select(jump_branch_mux_sel), 
		.mux_out(jump_branch));
	
	leftShifter #(.N(2)) jumpImmShifter (._in(jump_branch), ._out(jump_imm_shifted));
	
	concatenator jumpImmConcatenated (.a_in(pc_seq), .b_in(jump_imm_shifted), ._out(jump_imm_concatenated));
	
	adder pcBranchAdder (.a_in(pc_seq), .b_in(jump_imm_shifted), ._out(pc_branch_sum));
	
	alu branchChooser (.Func_in(alu_func), .A_in(reg_read1), .B_in(reg_read2), .O_out(), .Branch_out(branch_mux_sel),
		.Jump_out());
	
	twoInMux #(.W(32)) branchMux(.a_in(pc_seq), .b_in(pc_branch_sum), .select(branch_mux_sel), 
		.mux_out(branch_address));
		
	twoInMux #(.W(32)) jumpImmRegMux(.a_in(reg_read1), .b_in(jump_imm_concatenated), .select(jump_imm_reg_mux_sel), 
		.mux_out(jump_imm_reg));
		
	twoInMux #(.W(32)) jumpMux (.a_in(branch_address), .b_in(jump_imm_reg), .select(jump_mux_sel), 
		.mux_out(jump_address_out));
	
	// writeback modules
	
	adder pcWritebackAdder (.a_in(pc_seq_2), .b_in(32'h4), ._out(pc_writeback_sum));
	
	twoInMux #(.W(32)) regWriteDataMux (.a_in(reg_write_data), .b_in(pc_writeback_sum), .select(reg_write_data_mux_sel), .mux_out(reg_write_data_muxed));
	
endmodule