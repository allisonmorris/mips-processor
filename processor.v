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
	
	// wires
	wire [31:0] decode_next_address, 
	            fetch_instruction, 
					fetch_pc_seq,
					decode_pc_seq,
					decode_operand_a,
					decode_operand_b,
					decode_read_2,
					execute_pc_seq,
					execute_read_2,
					execute_alu,
					memory_pc_seq,
					memory_write_data;
	wire [13:0] decode_bundle;
	wire [4:0]  decode_write_dest,
	            execute_write_dest,
					memory_write_dest;
	wire [23:0] fetch_bundle;
	wire [25:0] fetch_writeback_bundle;
	wire [7:0]  execute_bundle;
	wire [1:0]  memory_bundle;
	wire        decode_jump_branch;
	
	
	
	assign fetch_writeback_bundle[23:0] = fetch_bundle;
	assign fetch_writeback_bundle[25:24] = memory_bundle[1:0];

	FetchModule fetch (.clk(clock), .reset(reset), .next_pc_in(decode_next_address), .instruction_out(fetch_instruction), 
		.bundle_out(fetch_bundle), .pc_seq_out(fetch_pc_seq), .jump_branch_in(decode_jump_branch));
	
	DecodeModule decodeWb (.clk(clock), .reset(reset), .bundle_in(fetch_writeback_bundle), .bundle_out(decode_bundle), .pc_seq_in(fetch_pc_seq), 
		.pc_seq_2_in(memory_pc_seq), .pc_seq_out(decode_pc_seq), .instr_in(fetch_instruction), .operand_a_out(decode_operand_a), 
		.operand_b_out(decode_operand_b), .reg_read2_out(decode_read_2), .reg_write_dest_in(memory_write_dest), .jump_branch_out(decode_jump_branch),
		.reg_write_dest_out(decode_write_dest), .reg_write_data_in(memory_write_data), .jump_address_out(decode_next_address));
	
	ExecuteModule execute (.clk(clock), .reset(reset), .bundle_in(decode_bundle), .bundle_out(execute_bundle), .pc_seq_in(decode_pc_seq), 
		.pc_seq_out(execute_pc_seq), .a_in(decode_operand_a), .b_in(decode_operand_b), .reg_write_dest_in(decode_write_dest), 
		.reg_write_dest_out(execute_write_dest), .reg_read2_in(decode_read_2), .reg_read2_out(execute_read_2), .alu_out(execute_alu));
	
	MemoryModule memory (.clk(clock), .reset(reset), .bundle_in(execute_bundle), .address_in(execute_alu), .reg_b_in(execute_read_2), 
		.write_reg_in(execute_write_dest), .write_reg_out(memory_write_dest), .bundle_out(memory_bundle), .pc_seq_in(execute_pc_seq), 
		.pc_seq_out(memory_pc_seq), .skip_ram_mux_out(memory_write_data), 
		.serial_in(serial_in), .serial_ready_in(serial_ready_in), .serial_valid_in(serial_valid_in), 
		.serial_out(serial_out), .serial_rden_out(serial_rden_out), .serial_wren_out(serial_wren_out));
					

	endmodule