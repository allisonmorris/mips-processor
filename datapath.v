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
	
	/* Alex's memory parameters */
	/* lab3-test: 
	parameter inst_mem_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab3-test.inst_rom.memh";
	parameter data_mem0_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab3-test.data_ram0.memh";
	parameter data_mem1_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab3-test.data_ram1.memh";
	parameter data_mem2_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab3-test.data_ram2.memh";
	parameter data_mem3_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab3-test.data_ram3.memh";
	 */
	parameter inst_mem_path = "C:/Alex/Documents/cse141/mips-processor/mem/nbhelloworld.inst_rom.memh";
	parameter data_mem0_path = "C:/Alex/Documents/cse141/mips-processor/mem/nbhelloworld.data_ram0.memh";
	parameter data_mem1_path = "C:/Alex/Documents/cse141/mips-processor/mem/nbhelloworld.data_ram1.memh";
	parameter data_mem2_path = "C:/Alex/Documents/cse141/mips-processor/mem/nbhelloworld.data_ram2.memh";
	parameter data_mem3_path = "C:/Alex/Documents/cse141/mips-processor/mem/nbhelloworld.data_ram3.memh";
	
	/* Bob's memory parameters */
	/*
	parameter inst_mem_path = "";
	parameter data_mem0_path = "";
	parameter data_mem1_path = "";
	parameter data_mem2_path = "";
	parameter data_mem3_path = "";
	*/
	
	// wires
	wire 	[31:0]	pc_out,
						adder_out,
						reg_read1_out,
						reg_read2_out,
						signExtend_out,
						alu_mux_out,
						alu_out,
						data_mem_out,
						data_mem_mux_out,
						instr_rom_out;
	wire [4:0]		instr_mux_out;

	//output instruction data to control
	assign inst_mem_opcode_out = instr_rom_out[31:26];
	assign inst_mem_func_out = instr_rom_out[5:0];
						
	//PC Register
	pc pcReg (.clk(clock),.reset(reset), .enable(pc_en_in), .data_in(adder_out), .q_out(pc_out));
	
	// PC Adder
	pcAdder pcInc (.data_in(pc_out),.pc_out(adder_out));
	
	// write pc mux
	twoInMux #(.W(32)) writePcMux(.a_in(), .b_in(), .mux_out());
	
	// adder for adding branch offsets to pc
	adder add (.a_in(), .b_in(), ._out());
	
	// sign extender for jumping
	signExtend #(.W(26)) jumpExtender (.i_in(), .extend_out());
	
	// jump/branch immediate mux -- mux for combining jump or branch offset for shifting
	twoInMux #(.W(32)) jumpBrnImmMux (.a_in(), .b_in(), .mux_out());
	
	// left shifter -- shift jump/branch offsets by 2
	leftShifter #(.N(2)) shifter (._in(), ._out());
	
	// concatenator -- concatenates jump offset to pc
	concatenator (._in(), ._out());
	
	// jump immediate/register mux -- determines whether to jump from imm or reg
	twoInMux #(.W(32)) jumpImmRegMux(.a_in(), .b_in(), .mux_out());
	
	// branch mux -- update pc if branching
	twoInMux #(.W(32)) brnMux (.a_in(), .b_in(), .mux_out());
	
	// jump mux -- update pc if jumping
	twoInMux #(.W(32)) jumpMux (.a_in(), .b_in(), .mux_out());
	
	
	
	//register file
	regfile regs (.clk(clock), .reset(reset), .enable(regfile_we_in), .readReg1_in( instr_rom_out[25:21]), 
		.readReg2_in(instr_rom_out[20:16] ), .writeReg_in(instr_mux_out), 
		.writeData_in(data_mem_mux_out), .data1_out(reg_read1_out), .data2_out(reg_read2_out));
				
	//Instruction Mux for write register
	twoInMux#(.W(5)) instMux (.a_in(instr_rom_out[20:16]), .b_in(instr_rom_out[15:11]), .mux_out(instr_mux_out), 
		.select(inst_mux_sel_in)); 
	
	// alu Mux PRE-ALU
	twoInMux#(.W(32)) aluMux (.a_in(reg_read2_out), .b_in(signExtend_out), .mux_out(alu_mux_out), .select(alu_mux_sel_in)); 
	
	//Data memory mux POST-ALU
	twoInMux#(.W(32)) dataMemMux (.a_in(alu_out), .b_in(data_mem_out), .mux_out(data_mem_mux_out), .select(data_mem_mux_sel_in)); 
	
	//Sign Extender for immediates
	signExtend extender (.i_in(instr_rom_out[15:0]), .extend_out(signExtend_out));
	
	// shift mux -- supply shamt or reg1 to alu
	twoInMux #(.W(32)) shiftMux(.a_in(), .b_in(), .mux_out());
	
	// sign extender -- extend shamt to 32 bits
	unsignExtend #(.W(5)) shiftExtender (.i_in(), .extend_out());
	
	//ALU
	alu math (.Func_in(alu_func_in), .A_in(reg_read1_out), .B_in(alu_mux_out), .O_out(alu_out), .Branch_out(alu_branch_out), 
		.Jump_out(alu_jump_out));
	
	//Instruction Rom
	inst_rom#(.INIT_PROGRAM(inst_mem_path), .ADDR_WIDTH(10)) rom (.clock(clock), .reset(reset), .addr_in(adder_out),
		.data_out(instr_rom_out));
		
	// Up shifter (for lui)
	upShifter us (._in(), ._out());
	
	// lui mux
	twoInMux #(.W(32)) luiMux (.a_in(), .b_in(), .mux_out());
	
	// data memory loader -- fore correcting loads
	dataMemoryLoader dmloader (._in(), .size_in(), .signed_in(), ._out());
	
	//Data Memory
	data_memory
	#(.INIT_PROGRAM0(data_mem0_path),
		.INIT_PROGRAM1(data_mem1_path),
		.INIT_PROGRAM2(data_mem2_path),
		.INIT_PROGRAM3(data_mem3_path))
		ram (.clock(clock), .reset(reset), .addr_in(alu_out), 
		.writedata_in(reg_read2_out), .we_in(data_mem_we_in),.readdata_out(data_mem_out),
		.re_in(data_mem_re_in), .size_in(data_mem_size_in), 
		.serial_in(serial_in), .serial_ready_in(serial_ready_in), .serial_valid_in(serial_valid_in), 
		.serial_out(serial_out), .serial_rden_out(serial_rden_out), .serial_wren_out(serial_wren_out));

endmodule		