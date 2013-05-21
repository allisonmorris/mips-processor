
module FetchModule (input clk, input reset, input [31:0] next_pc_in, output reg [31:0] instruction_out, output reg [25:0] bundle_out,
	output [31:0] pc_seq_out);

	wire [31:0] 	next_pc,
						pc_seq,
						pc_Adder_out,
						rom_out,
						nop_mux_out;
	wire				pc_en,
						pc_inc_en,
						jump_mux_out,
						reg_write_data_mux_sel,
						reg_write_reg_mux_sel,
						regfile_we,
						alu_mux_sel,
						data_mem_re,
						data_mem_we,
						data_mem_mux_sel,
						jump_brn_imm_mux_sel,
						brn_mux_sel,
						jump_mux_sel,
						lui_mux_sel,
						data_mem_signed,
						alu_branch,
						alu_jump,
						extender_mux_sel,
						nop_mux_en,
						shift_mux_sel,
						jump_imm_reg_mux_sel
						;
	wire [5:0]		opcode, func, alu_func;
	wire [4:0]		code;
	wire [1:0]		mem_size;
	reg [31:0]		nop;
	
	assign instruction_out = nop_mux_out;
	assign opcode = rom_out[31:26];
	assign func = rom_out[6:0];
	assign code = rom_out[21:17];
	assign bundle_out[0] = regfile_we;
	assign bundle_out[1] = reg_write_data_mux_sel;
	assign bundle_out[2] = data_mem_re;
	assign bundle_out[3] = data_mem_we;
	assign bundle_out[5:4] = mem_size;
	assign bundle_out[6] = data_mem_signed;
	assign bundle_out[7] = data_mem_mux_sel;
	assign bundle_out[14:8] = func;
	assign bundle_out[15:14] = reg_write_reg_mux_sel;
	assign bundle_out[16] = shift_mux_sel;
	assign bundle_out[17] = alu_mux_sel;
	assign bundle_out[18] = lui_mux_sel;
	assign bundle_out[19] = extender_mux_sel;
	assign bundle_out[20] = jump_brn_imm_mux_sel;
	assign bundle_out[21] = brn_mux_sel;
	assign bundle_out[22] = jump_mux_sel;
	assign bundle_out[23] = jump_imm_reg_mux_sel;
	assign bundle_out[24] = regfile_we;
	assign bundle_out[25] = reg_write_data_mux_sel;
	
	assign pc_seq_out = pc_seq;
	
	//Need no op instruction
	assign nop = 32'b00110100000000000000000000000000; // ori $zero,$zero,0
	

	//Modules
	// Need to add instruction / no op mux
	
	twoInMux#(.W(32)) nopMux (.a_in(rom_out), .b_in(nop), .mux_out(nop_mux_out), 
		.select(nop_mux_en)); 
	
	//PC Register
	pc pcReg (.clk(clk),.reset(reset), .enable(pc_inc_en), .data_in(next_pc_in), .q_out(next_pc));
	
	// PC Adder
	pcAdder pcInc (.data_in(next_pc),.pc_out(pc_seq));

	//Instruction Rom
	inst_rom#(.INIT_PROGRAM(inst_mem_path), .ADDR_WIDTH(10)) rom (.clock(clock), .reset(reset), .addr_in(next_pc),
		.data_out(rom_out));	

	//Control Module	
	control cp (.opcode_in(opcode), 
					.func_in(func), 
					.pc_enable_out(pc_en), 
					.instr_mux_select_out(reg_write_reg_mux_sel),
					.regfile_we_out(regfile_we),
					.alu_mux_select_out(alu_mux_sel),
					.alu_func_out(alu_func), 
					.data_mem_re_out(data_mem_re), 
					.data_mem_we_out(data_mem_we), 
					.data_mem_mux_select_out(data_mem_mux_sel), 
					.data_mem_size_out(mem_size), 
					.jmp_brn_mux_select_out(jump_brn_imm_mux_sel),
					.shift_mux_select_out(shift_mux_sel), 
					.jmp_immreg_mux_select_out(jump_imm_reg_mux_sel),
					.brn_mux_select_out(brn_mux_sel),
					.jmp_mux_select_out(jump_mux_sel),
					.lui_mux_select(lui_mux_sel),
					.wrdata_mux_select(reg_write_data_mux_sel),
					.signed_out(data_mem_signed),
					.branch_in(alu_branch),
					.jump_in(alu_jump),
					.code_in(code),
					.extender_mux_select_out(extender_mux_sel),
					.nop_out(nop_mux_en)
					);

endmodule