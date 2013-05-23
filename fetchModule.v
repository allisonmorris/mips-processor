
module FetchModule (input clk, input reset, input [31:0] next_pc_in, output [31:0] instruction_out, output [23:0] bundle_out,
	output [31:0] pc_seq_out);

	wire [31:0] 	next_pc,
						pc_seq,
						rom_out,
						nop_mux_out;
	wire [31:0]		nop;
	wire [23:0]		nop_bundle, bundle_mux_out;
	wire [25:0]    bundle;
	wire           pc_inc_en;
	
	assign instruction_out = nop_mux_out;
	assign bundle_out = bundle_mux_out;
	assign pc_seq_out = pc_seq;
	assign pc_inc_en = ~bundle[25];
	
	//Need no op instruction
	assign nop = 32'b00110100000000000000000000000000; // ori $zero,$zero,0 0x34000000
	// assign nop_bundle = 24'b100001100010000000110001; //leave as binary for debug. this doesn't look quite right...
	assign nop_bundle =    24'b000011100010010100110001; // 0x0E2531
	parameter inst_mem_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab4/branchdelay.inst_rom.memh";

	// PC Register
	register #(.W(32), .D(32'h00400000))pcReg (.clk(clk),.reset(reset), .enable(pc_inc_en), .data_in(next_pc_in), .q_out(next_pc));
	
	//Modules
	// Need to add instruction / no op mux
	
	twoInMux#(.W(24)) bundleMux (.a_in(bundle[23:0]), .b_in(nop_bundle), .mux_out(bundle_mux_out), 
		.select(pc_inc_en)); 
		
	twoInMux#(.W(32)) nopMux (.a_in(rom_out), .b_in(nop), .mux_out(nop_mux_out), 
		.select(pc_inc_en));
	
	// PC Adder
	adder pcInc (.a_in(next_pc), .b_in(32'h4), ._out(pc_seq));

	//Instruction Rom
	inst_rom#(.INIT_PROGRAM(inst_mem_path), .ADDR_WIDTH(10)) rom (.clock(clk), .reset(reset), .addr_in(next_pc),
		.data_out(rom_out));	

	//Control Module	
	control ctrl (.clk(clk), .reset(reset), .instr_in(rom_out), .bundle_out(bundle));
endmodule