`timescale 1ns/1ps

module datapath(
	input clock,
	input reset,
	
	//output to control
	output [5:0] inst_mem_opcode_out,
	output [5:0] inst_mem_func_out,
	output alu_jump_out,
	output alu_branch_out,
	
	//input from control
	input pc_en_in,
	input inst_mux_sel_in,
	input regfile_we_in,
	input alu_mux_sel_in,
	input [5:0] alu_func_in,
	input data_mem_re_in,
	input data_mem_we_in,
	input [1:0] data_mem_size_in,
	input data_mem_mux_sel_in,
	
	//serial stuff
	input [7:0] serial_in,
	input serial_valid_in,
	input serial_ready_in,
	output [7:0] serial_out,
	output serial_rden_out,
	output serial_wren_out
	);
	
	// wires
	wire 	[31:0]	pc_out,
						adder_out,
						instr_mem_out,
						reg_read1_out,
						reg_read2_out,
						signExtend_out,
						alu_mux_out,
						alu_out,
						data_mem_out,
						data_mem_mux_out,
						instr_rom_out;
	wire [5:0]		instr_mux_out;

	//output instruction data to control
	assign inst_mem_opcode_out = instr_rom_out[31:26];
	assign inst_mem_func_out = instr_rom_out[5:0];
						
	//PC Register
	pc(.clk(clock),.reset(reset), .enable(pc_en_in), .data_in(adder_out), .q_out(pc_out));
	
	//Adder
	pcAdder(.data_in(pc_out),.pc_out(adder_out));
	
	//Instruction Memory !!! REGFILE
	regfile(.clk(clock), .reset(reset), .enable(regfile_we_in), .readReg1_in( instr_rom_out[25:21]), 
		.readReg2_in(instr_rom_out[20:16] ), .writeReg_in(instr_rom_out[15:11]), 
		.writeData_in(data_mem_mux_out));
				
	//Instruction Mux
	twoInMux#(.W(8))(.a_in(instr_mem_out[20:16]), .b_in(instr_mem_out[15:11]), .mux_out(instr_mux_out), 
		.select(inst_mux_sel_in)); 
	
	// Data Memory / Register Mux
	twoInMux#(.W(32))(.a_in(reg_read2_out), .b_in(signExtend_out), .mux_out(instr_mux_out), .select(data_mem_mux_sel_in)); 
	
	//Data memory / alu Mux
	twoInMux#(.W(32))(.a_in(alu_out), .b_in(data_mem_out), .mux_out(data_mem_mux_out), .select(alu_mux_sel_in)); 
	
	//Sign Extender
	signExtend(.i_in(instr_rom_out[15:0]), .extend_out(signExtend_out));
	
	//ALU
	alu(.Func_in(alu_func_in), .A_in(reg_read1_out), .B_in(alu_mux_out), .O_out(alu_out), .Branch_out(alu_branch_out), 
		.Jump_out(alu_jump_out));
	
	//Instruction Rom
	inst_rom#(.INIT_PROGRAM("C:/Alex/Documents/cse141/lab2/blank.memh"))(.clock(clock), .reset(reset), .addr_in(adder_out),
		.data_out(instr_rom_out));
	
	//Data Memory
	data_memory
	#(.INIT_PROGRAM0("C:/Alex/Documents/cse141/lab2/blank.memh"),
		.INIT_PROGRAM1("C:/Alex/Documents/cse141/lab2/blank.memh"),
		.INIT_PROGRAM2("C:/Alex/Documents/cse141/lab2/blank.memh"),
		.INIT_PROGRAM3("C:/Alex/Documents/cse141/lab2/blank.memh"))
		(.clock(clock), .reset(reset), .addr_in(alu_out), 
		.writedata_in(reg_read2_out), .we_in(data_mem_we_in),.readdata_out(data_mem_out),
		.re_in(data_mem_re_in), .size_in(data_mem_size_in), 
		.serial_in(serial_in), .serial_ready_in(serial_ready_in), .serial_valid_in(serial_valid_in), 
		.serial_out(serial_out), .serial_rden_out(serial_rden_out), .serial_wren_out(serial_wren_out));

endmodule		