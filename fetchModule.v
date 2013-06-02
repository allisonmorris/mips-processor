
module FetchModule (input clk, input reset, input [31:0] next_pc_in, output [31:0] instruction_out, output [23:0] bundle_out,
	output [31:0] pc_seq_out, input jump_branch_in);

	wire [31:0] 	next_pc,
	               next_reg_pc,
						next_reg_pc_z,
						next_reg_pc_z_muxed,
						next_reg_pc_2,
						pc_seq,
						rom_out,
						nop_mux_out;
	wire [31:0]		nop;
	wire [23:0]		nop_bundle, bundle_mux_out;
	wire [25:0]    bundle;
	wire           pc_inc_en,
	               z_stall_sel,
	               jump_branch,
						jump_branch_z,
						jump_branch_z_muxed,
						jump_branch_rest_mux_sel;
	
	assign instruction_out = nop_mux_out;
	assign bundle_out = bundle_mux_out;
	assign pc_inc_en = ~bundle[25];
	
	//Need no op instruction
	assign nop = 32'b00110100000000000000000000000000; // ori $zero,$zero,0 0x34000000
	// assign nop_bundle = 24'b100001100010000000110001; //leave as binary for debug. this doesn't look quite right...
	assign nop_bundle =    24'b000011100010010100110001; // 0x0E2531
	
	// Alex
	//parameter inst_mem_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab5/testBasicMem.rom.memh";

	parameter inst_mem_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab5/test.inst_rom.memh";
	//parameter inst_mem_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab4/hello_world.inst_rom.memh";
	// Bob
	//parameter inst_mem_path = "Z:/heybob/Dropbox/cse141l/lab5/testcases/memory/simpleArith.inst_rom.memh";

	// PC Register
	register #(.W(32), .D(32'h003ffffc)) pcRegZ (.clk(clk),.reset(reset), .enable(z_stall_sel), .data_in(next_pc_in), .q_out(next_reg_pc_z));
	register #(.W(32), .D(32'h003ffffc)) pcReg (.clk(clk),.reset(reset), .enable(pc_inc_en), .data_in(next_reg_pc_z_muxed), .q_out(next_reg_pc));
	register #(.W(32), .D(32'h00400000)) pcReg2 (.clk(clk), .reset(reset), .enable(pc_inc_en), .data_in(pc_seq), .q_out(next_reg_pc_2));
	register #(.W(1), .D(1'b0)) jbRegZ (.clk(clk), .reset(reset), .enable(z_stall_sel), .data_in(jump_branch_in), .q_out(jump_branch_z));
	register #(.W(1), .D(1'b0)) jbReg (.clk(clk), .reset(reset), .enable(pc_inc_en), .data_in(jump_branch_z_muxed), .q_out(jump_branch));
	register #(.W(1), .D(1'b0)) jbReg2 (.clk(clk), .reset(reset), .enable(pc_inc_en), .data_in(jump_branch), .q_out(jump_branch_rest_mux_sel));
	register #(.W(1), .D(1'b1)) stallReg (.clk(clk), .reset(reset), .enable(1'b1), .data_in(pc_inc_en), .q_out(z_stall_sel));
	
	//Modules
	
	// create a stall counter
	//counter stallCount ( .clk(clk), .reset(reset),.pc_en(pc_inc_en), .count(cnt));
	
	// pc and jb zero-th register muxes
	twoInMux #(.W(32)) pcRegZMux (.a_in(next_reg_pc_z), .b_in(next_pc_in), .select(z_stall_sel), .mux_out(next_reg_pc_z_muxed));
	twoInMux #(.W(1)) jbRegZMux (.a_in(jump_branch_z), .b_in(jump_branch_in), .select(z_stall_sel), .mux_out(jump_branch_z_muxed));
	
	// jump/branch restorer mux
	twoInMux #(.W(32)) jbRestMux (.a_in(next_reg_pc), .b_in(next_reg_pc_2), .select(jump_branch_rest_mux_sel), .mux_out(next_pc));
	
	// Need to add instruction / no op mux
	
	twoInMux#(.W(24)) bundleMux (.b_in(bundle[23:0]), .a_in(nop_bundle), .mux_out(bundle_mux_out), 
		.select(pc_inc_en)); 
		
	twoInMux#(.W(32)) nopMux (.b_in(rom_out), .a_in(nop), .mux_out(nop_mux_out), 
		.select(pc_inc_en));
	
	// need to stop incrementing if we're stalling
	twoInMux #(.W(32)) stallPCSeqMux(.b_in(pc_seq), .a_in(next_pc), .select(pc_inc_en), .mux_out(pc_seq_out));
	
	// PC Adder
	adder pcInc (.a_in(next_pc), .b_in(32'h4), ._out(pc_seq));

	//Instruction Rom
	inst_rom#(.INIT_PROGRAM(inst_mem_path), .ADDR_WIDTH(10)) rom (.clock(clk), .reset(reset), .addr_in(next_pc),
		.data_out(rom_out));	

	//Control Module	
	control ctrl (.clk(clk), .reset(reset), .instr_in(rom_out), .bundle_out(bundle));
endmodule
