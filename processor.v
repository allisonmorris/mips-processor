module processor(
	input clock,
	input reset,
	input [7:0] serial_in,
	input serial_valid_in,
	input serial_ready_in,
	output [7:0] serial_out,
	output serial_rden_out,
	output serial_wren_out
	);
	

	//wires named by datapath
	wire [5:0] inst_mem_opcode,
				  inst_mem_func,
				  alu_func;
	
	wire [1:0] data_mem_size;
	
	// wires
	wire  alu_jump,
			alu_branch,
			pc_en,
			//inst_mux_sel, updated in lab 4
			regfile_we,
			alu_mux_sel,
			data_mem_re,
			data_mem_we,
			data_mem_mux_sel;
	
	//wires from lab 4
	wire [1:0] inst_mux_sel;
	wire       wrdata_mux_sel,
				  jump_brn_imm_mux_sel,
				  lui_mux_sel,
				  shift_mux_sel,
				  brn_mux_sel,
				  jump_imm_reg_mux_sel,
				  jump_mux_sel,
				  data_mem_signed;
					
	
	control cp (.opcode_in(inst_mem_opcode), .func_in(inst_mem_func), .pc_enable_out(pc_en), 
		.instr_mux_select_out(inst_mux_sel), .regfile_we_out(regfile_we), .alu_mux_select_out(alu_mux_sel),
		.alu_func_out(alu_func), .data_mem_re_out(data_mem_re), .data_mem_we_out(data_mem_we), 
		.data_mem_mux_select_out(data_mem_mux_sel), .data_mem_size_out(data_mem_size), 
		.jmp_brn_mux_select_out(jump_brn_imm_mux_sel), .shift_mux_select_out(shift_mux_sel), 
		.jmp_immreg_mux_select_out(jump_imm_reg_mux_sel), .brn_mux_select_out(brn_mux_sel),
		.jmp_mux_select_out(jump_mux_sel), .lui_mux_select(lui_mux_sel), .wrdata_mux_select(wrdata_mux_sel),
		.signed_out(data_mem_signed));
	
	datapath dp (.clock(clock), .reset(reset), .inst_mem_opcode_out(inst_mem_opcode), 
		.inst_mem_func_out(inst_mem_func), .alu_jump_out(alu_jump), .alu_branch_out(alu_branch), 
		.pc_en_in(pc_en), .inst_mux_sel_in(inst_mux_sel), .regfile_we_in(regfile_we), .alu_mux_sel_in(alu_mux_sel),
		.alu_func_in(alu_func), .data_mem_re_in(data_mem_re), .data_mem_we_in(data_mem_we), 
		.data_mem_size_in(data_mem_size), .data_mem_mux_sel_in(data_mem_mux_sel), 
		.wrdata_mux_sel_in(wrdata_mux_sel), .jump_brn_imm_mux_sel_in(jump_brn_imm_mux_sel), .lui_mux_sel_in(lui_mux_sel), 
		.shift_mux_sel_in(shift_mux_sel), .brn_mux_sel_in(brn_mux_sel), .jump_imm_reg_mux_sel_in(jump_imm_reg_mux_sel),
		.jump_mux_sel_in(jump_mux_sel), .data_mem_signed_in(data_mem_signed),
		.serial_in(serial_in), .serial_ready_in(serial_ready_in), .serial_valid_in(serial_valid_in), 
		.serial_out(serial_out), .serial_rden_out(serial_rden_out), .serial_wren_out(serial_wren_out));
	

	endmodule