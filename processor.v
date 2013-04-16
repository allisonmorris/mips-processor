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
	
	//wires
	wire [5:0] dpath_opcode_out,
				  dpath_func_out,
				  alu_func_in;
	
	wire [1:0] data_mem_size_in;
	
	wire  dpath_jump_out,
			dpath_branch_out,
			pc_en_in,
			inst_mux_sel_in,
			regfile_we_in,
			alu_mux_sel_in,
			data_mem_re_in,
			data_mem_we_in,
			data_mem_mux_sel_in;
	
	
	control (.opcode_in(), .pc_en_out());
	
	datapath ();
	

	endmodule