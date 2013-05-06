`timescale 1ns/1ps

module control(
	input [5:0] opcode_in,
	input [5:0] func_in,
	input [4:0] code_in,
	input jump_in,
	input branch_in,
	output reg pc_enable_out,
	output reg [1:0]instr_mux_select_out,
	output reg regfile_we_out,
	output reg alu_mux_select_out,
	output reg [5:0] alu_func_out,
	output reg data_mem_re_out,
	output reg data_mem_we_out,
	output reg data_mem_mux_select_out,
	output reg [1:0] data_mem_size_out,
	output reg jmp_brn_mux_select_out,
	output reg shift_mux_select_out,
	output reg jmp_immreg_mux_select_out,
	output reg brn_mux_select_out,
	output reg jmp_mux_select_out,
	output reg lui_mux_select,
	output reg wrdata_mux_select,
	output reg signed_out,
	output reg extender_mux_select_out
	);

	//Opcode constants
	parameter op_arith =	6'b000000;
	parameter op_lw =		6'b100011;
	parameter op_sw = 	6'b101011;
	parameter op_addi = 	6'b001000;
	parameter op_addiu = 6'b001001;
	parameter op_andi = 	6'b001100;
	parameter op_ori = 	6'b001101;
	parameter op_xori = 	6'b001110;
	parameter op_lui = 	6'b001111;
	parameter op_slti = 	6'b001010;
	parameter op_sltiu = 6'b001011;
	parameter op_beq = 	6'b000100;
	parameter op_bne = 	6'b000101;
	parameter op_bltz_bgez = 	6'b000001; //same opcode for bgez 
	parameter op_blez = 	6'b000110;
	parameter op_bgtz = 	6'b000111;
	parameter op_j = 		6'b000010;
	parameter op_jal = 	6'b000011;
	parameter op_lb = 	6'b100000;
	parameter op_lh = 	6'b100001;
	parameter op_sb = 	6'b101000;
	parameter op_sh = 	6'b101001;
	parameter op_lbu = 	6'b100100;
	parameter op_lhu = 	6'b100101;
	
	
	// Codes for branches
	parameter code_bltz = 	5'b00000;
	parameter code_blez = 	5'b00000;
	parameter code_bgtz = 	5'b00000;
	parameter code_bgez = 	5'b00001;
	
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
	parameter func_jr =		6'b001000;		//jr and j
	parameter func_jalr =	6'b001001;		//jalr and jal
	
	// following are pseudo-funcs for alu
	parameter func_bltz =	6'b001010;	
	parameter func_bgez =	6'b001011;
	parameter func_beq =		6'b001100;
	parameter func_bne =		6'b001101;
	parameter func_blez =	6'b001110;
	parameter func_bgtz =	6'b001111;
	
	
	// wire constants
	parameter high =			1'b1;
	parameter low =			1'b0;
	parameter select_a =		2'b00;
	parameter select_b =		2'b01;
	parameter select_c = 	2'b10;
	parameter select_d =    2'b11;
	parameter size_word =	2'b11;
	parameter size_byte =	2'b00;
	parameter size_hw =		2'b01;

	always @(*) begin
		// handle R type
		if (opcode_in == 6'b000000) begin
			pc_enable_out = high;	
			alu_func_out = func_in[5:0];
			alu_mux_select_out = low;
			data_mem_re_out = low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = low;
			jmp_brn_mux_select_out = low;
			jmp_immreg_mux_select_out = low;
			 brn_mux_select_out = branch_in;
			jmp_mux_select_out = jump_in;
			lui_mux_select = low;
			signed_out = low;
			extender_mux_select_out = low;
			//shifts
			if (func_in[5:3] == 3'b000) begin
				instr_mux_select_out = select_b;
				regfile_we_out = high;
				wrdata_mux_select = low;
				if (func_in[2] == 1'b0) begin
					shift_mux_select_out = high;
				end else begin
					shift_mux_select_out = low;
				end
			//jumps
			end else if (func_in[5:3] == 3'b001) begin
				shift_mux_select_out = low;
				if (func_in[0] == 1'b0) begin
					instr_mux_select_out = select_a;
					regfile_we_out = low;
					wrdata_mux_select = low;
				end else begin
					instr_mux_select_out = select_c;
					regfile_we_out = high;
					wrdata_mux_select = high;
				end
			//default R type
			end else begin
				instr_mux_select_out = select_b;
				regfile_we_out = high;
				shift_mux_select_out = low; 
				wrdata_mux_select = low;
			end
		// handle  norml I type
		end else if (opcode_in[5:3] == 3'b001) begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_a;
			regfile_we_out= high;
			alu_mux_select_out = high;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = low;
			jmp_brn_mux_select_out = low;
			shift_mux_select_out = low;
			jmp_immreg_mux_select_out = low;
			brn_mux_select_out = low;
			jmp_mux_select_out = low;
			wrdata_mux_select = low;
			signed_out = low;	
			// I type variations
			case (opcode_in[5:0])
				op_addi: begin
					alu_func_out = func_add;
					lui_mux_select = high;
					extender_mux_select_out = low;
				end
				op_addiu: begin
					alu_func_out = func_add;
					lui_mux_select = high;
					extender_mux_select_out = low;
				end
				op_lui: begin
					alu_func_out = func_add;
					lui_mux_select = low;
					extender_mux_select_out = low;
				end
				op_slti: begin
					alu_func_out = func_slt;
					lui_mux_select = high;
					extender_mux_select_out = low;
				end
				op_andi: begin
					alu_func_out = func_and;
					lui_mux_select = high;
					extender_mux_select_out = high;
				end
				op_ori: begin
					alu_func_out = func_or;
					lui_mux_select = high;
					extender_mux_select_out = high;
				end
				op_xori: begin
					alu_func_out = func_xor;
					lui_mux_select = high;
					extender_mux_select_out = high;
				end
				default: begin
					regfile_we_out = low;
					alu_func_out = func_slt;
					lui_mux_select = high;
					extender_mux_select_out = low;
				end
			endcase
		// handle J type
		end else if (opcode_in[5:1] == 5'b00001) begin
			pc_enable_out =	high;	
			alu_func_out = func_jr;
			alu_mux_select_out = low;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = low;
			jmp_brn_mux_select_out = high;
			shift_mux_select_out = low;
			jmp_immreg_mux_select_out = high;
			 brn_mux_select_out = low;
			jmp_mux_select_out = high;
			lui_mux_select = high;
			wrdata_mux_select = high;
			signed_out = low;		
			extender_mux_select_out = low;
			// j
			if (opcode_in[0] == 0) begin
				instr_mux_select_out = select_a;
				regfile_we_out = low;
			// jal
			end else begin
				instr_mux_select_out = select_c;
				regfile_we_out = high;
			end
		// handle branches (I type)
		end else if (opcode_in[5:2] == 5'b0001) begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_a;
			regfile_we_out= low;
			alu_mux_select_out = low;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = low;
			jmp_brn_mux_select_out = low;
			shift_mux_select_out = low;
			jmp_immreg_mux_select_out = high;
			 brn_mux_select_out = branch_in;
			jmp_mux_select_out = low;
			lui_mux_select = high;
			wrdata_mux_select = low;
			signed_out = low;	
			extender_mux_select_out = low;
			// func code variations
			case (opcode_in[5:0])
				op_beq: begin
					alu_func_out = func_beq;
				end
				op_bne: begin
					alu_func_out = func_bne;
				end
				op_blez: begin
					alu_func_out = func_blez;
				end
				op_bgtz: begin
					alu_func_out = func_bgtz;
				end
				default: begin
					alu_func_out = func_add;
				end
			endcase
		// handle memory
		end else if (opcode_in[5:4] == 2'b10) begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_a;
			alu_func_out = func_add;
			alu_mux_select_out = high;
			data_mem_size_out = opcode_in[1:0];
			data_mem_mux_select_out = high;
			jmp_brn_mux_select_out = low;
			shift_mux_select_out = low;
			jmp_immreg_mux_select_out = low;
			 brn_mux_select_out = branch_in;
			jmp_mux_select_out = jump_in;
			lui_mux_select = high;
			wrdata_mux_select = low;
			extender_mux_select_out = low;
			// stores
			if (opcode_in[3] == 1'b1) begin
				regfile_we_out = low;
				data_mem_re_out = low;
				data_mem_we_out = high;
				signed_out = low;
			// loads
			end else begin
				regfile_we_out = high;
				data_mem_re_out = high;
				data_mem_we_out = low;
				signed_out = opcode_in[2];
			end
		// bltz and begz sadly need their own case... poor mips design...
		end else if (opcode_in == op_bltz_bgez) begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_a;
			regfile_we_out= low;
			alu_mux_select_out = low;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = low;
			jmp_brn_mux_select_out = low;
			shift_mux_select_out = low;
			jmp_immreg_mux_select_out = high;
			 brn_mux_select_out = branch_in;
			jmp_mux_select_out = low;
			lui_mux_select = high;
			wrdata_mux_select = low;
			signed_out = low;	
			extender_mux_select_out = low;
			if (code_in == code_bltz) begin
				alu_func_out = func_bltz;
			end else begin
				alu_func_out = func_bgez;
			end
		// default nop-add
		end else begin
			pc_enable_out = high;	
			alu_func_out = func_add;
			alu_mux_select_out = low;
			data_mem_re_out = low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = low;
			jmp_brn_mux_select_out = low;
			jmp_immreg_mux_select_out = low;
			 brn_mux_select_out = low;
			jmp_mux_select_out = low;
			lui_mux_select = low;
			signed_out = low;
			extender_mux_select_out = low;
			instr_mux_select_out = select_b;
			regfile_we_out = low;
			shift_mux_select_out = low; 
			wrdata_mux_select = low;
		end
	end
endmodule