`timescale 1ns/1ps

module test_control_2();
	reg [5:0] opcode_in;
	reg [5:0] func_in;
	reg [4:0] code_in;
	reg jump_in;
	reg branch_in;
	wire pc_enable_out;
	wire [1:0] instr_mux_select_out;
	wire regfile_we_out;
	wire alu_mux_select_out;
	wire [5:0] alu_func_out;
	wire data_mem_re_out;
	wire data_mem_we_out;
	wire data_mem_mux_select_out;
	wire [1:0] data_mem_size_out;
	wire jmp_brn_mux_select_out;
	wire shift_mux_select_out;
	wire jmp_immreg_mux_select_out;
	wire brn_mux_select_out;
	wire jmp_mux_select_out;
	wire lui_mux_select;
	wire wrdata_mux_select;
	wire signed_out;
	
	//Opcode constants
	parameter op_arith =	6'b000000;
	parameter op_lw =		6'b100011;
	parameter op_sw = 	6'b101011;
	parameter op_addi = 	6'b001000;
	parameter op_addui = 6'b001001;
	parameter op_andi = 	6'b001100;
	parameter op_ori = 	6'b001101;
	parameter op_xori = 	6'b001110;
	parameter op_lui = 	6'b001111;
	parameter op_slti = 	6'b001010;
	parameter op_sltiu = 6'b001011;
	parameter op_beq = 	6'b000100;
	parameter op_bne = 	6'b000101;
	parameter op_bltz = 	6'b000001; //same opcode for bgez 
	parameter op_blez = 	6'b000110;
	parameter op_bgtz = 	6'b000111;
	parameter op_j = 		6'b000010;
	parameter op_jal = 	6'b000011;
	parameter op_jar = 	6'b000011;
	parameter op_lb = 	6'b100000;
	parameter op_lh = 	6'b100001;
	parameter op_sb = 	6'b101000;
	parameter op_sh = 	6'b101001;
	parameter op_lbu = 	6'b100100;
	parameter op_lhu = 	6'b100101;

	//Func constants
	parameter func_and =		6'b100100;
	parameter func_or =		6'b100101;
	parameter func_nor =		6'b100111;
	parameter func_xor =		6'b100110;
	parameter func_add =		6'b100000;
	parameter func_addu =	6'b100001;
	parameter func_sub=		6'b100010;
	parameter func_subu =	6'b100011;
	parameter func_slt=		6'b101000; 		
	parameter func_sltu=		6'b101001;		
	parameter func_sll=		6'b000000;
	parameter func_srl =		6'b000010;
	parameter func_sra =		6'b000011;
	parameter func_sllv =	6'b000100;
	parameter func_srlv =	6'b000110;
	parameter func_srav =	6'b000111;
	parameter func_jr =		6'b001000;		
	parameter func_jalr =	6'b001001;
	parameter func_bltz =	6'b111000;
	parameter func_bgez =	6'b111001;
	parameter func_beq =		6'b111100;
	parameter func_bne =		6'b111101;
	parameter func_blez =	6'b111110;
	parameter func_bgtz =	6'b111111;
	
	// Codes for branches
	parameter code_bltz = 	5'b00000;
	parameter code_blez = 	5'b00000;
	parameter code_bgtz = 	5'b00000;
	parameter code_bgez = 	5'b00001;


	control dut(.opcode_in(opcode_in),
					.func_in(func_in), 
					.code_in(code_in), 
					.jump_in(jump_in),
					.branch_in(branch_in),
					.pc_enable_out(pc_enable_out), 
					.instr_mux_select_out(instr_mux_select_out),
					.regfile_we_out(regfile_we_out), 
					.alu_mux_select_out(alu_mux_select_out), 
					.alu_func_out(alu_func_out), 
					.data_mem_re_out(data_mem_re_out),
					.data_mem_we_out(data_mem_we_out), 
					.data_mem_mux_select_out(data_mem_mux_select_out), 
					.data_mem_size_out(data_mem_size_out),
					.jmp_brn_mux_select_out(jmp_brn_mux_select_out),
					.shift_mux_select_out(shift_mux_select_out),
					.jmp_immreg_mux_select_out(jmp_immreg_mux_select_out),
					.brn_mux_select_out(brn_mux_select_out),
					.jmp_mux_select_out(jmp_mux_select_out),
					.lui_mux_select(lui_mux_select),
					.wrdata_mux_select(wrdata_mux_select),
					.signed_out(signed_out)
					);
	
	initial
		begin
			jump_in = 0;
			branch_in = 0;
			code_in = 0;
			opcode_in = op_arith;
			func_in = func_add;
			#10
			opcode_in = op_arith;
			func_in = func_sub;
			#10
			opcode_in = op_arith;
			func_in = func_and;
			#10
			opcode_in = op_arith;
			func_in = func_or;
			#10
			opcode_in = op_arith;
			func_in = func_nor;
			#10
			opcode_in = op_arith;
			func_in = func_xor;
			#10
			opcode_in = op_arith;
			func_in = func_addu;
			#10
			opcode_in = op_addui;
			#10
			opcode_in = op_arith;
			func_in = func_subu;
			#10
			opcode_in = op_addi;
			func_in = func_add;
			#10
			opcode_in = op_andi;
			#10
			opcode_in = op_ori;
			#10
			opcode_in = op_xori;
			#10
			opcode_in = op_lui;
			#10
			opcode_in = op_arith;
			func_in = func_slt;
			#10
			opcode_in = op_arith;
			func_in = func_sltu;
			#10
			opcode_in = op_slti;
			#10
			opcode_in = op_sltiu;
			#30
			
			
			//Loads
			
			opcode_in = op_lw;
			func_in = func_add;
			#10
			opcode_in = op_lb;
			#10
			opcode_in = op_lh;
			#10
			opcode_in = op_lbu;
			#10
			opcode_in = op_lhu;
			#10
			
			
			//Stores
			opcode_in = op_sw;
			func_in = func_add;
			#10
			opcode_in = op_sb;
			#10
			opcode_in = op_sh;
			#10
			//Branch Opcodes
			opcode_in = op_beq;
			func_in = func_beq;
			#10
			opcode_in = op_bne;
			func_in = func_bne;
			#10
			opcode_in = op_bltz;
			func_in = func_bltz;
			code_in = code_bltz;
			#10
			opcode_in = op_bltz;
			func_in = func_bgez;
			code_in = code_bgez;
			#10
			opcode_in = op_blez;
			func_in = func_blez;
			code_in = code_blez;
			#10
			opcode_in = op_bgtz;
			func_in = func_bgtz;
			code_in = code_bgtz;
			#30
			
			//Jump Instructions
			opcode_in = op_j;
			#10
			opcode_in = op_arith;
			func_in = func_jr;
			#10
			opcode_in = op_jal;
			#10
			opcode_in = op_jal;
			#10
			opcode_in = op_arith;
			func_in = func_jalr;
			#30
			
			// Shift Instructions
			opcode_in = op_arith;
			func_in = func_sll;
			#10
			opcode_in = op_arith;
			func_in = func_srl;
			#10
			opcode_in = op_arith;
			func_in = func_sra;
			#10
			opcode_in = op_arith;
			func_in = func_sllv;
			#10
			opcode_in = op_arith;
			func_in = func_srlv;
			#10
			opcode_in = op_arith;
			func_in = func_srav;
		end
endmodule