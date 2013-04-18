`timescale 1ns/1ps

module control(
	input [5:0] opcode_in,
	input [5:0] func_in,
	output reg pc_enable_out,
	output reg instr_mux_select_out,
	output reg regfile_we_out,
	output reg alu_mux_select_out,
	output reg [5:0] alu_func_out,
	output reg data_mem_re_out,
	output reg data_mem_we_out,
	output reg data_mem_mux_select_out,
	output reg [1:0] data_mem_size_out
	);

//Opcode constants
parameter op_arith =	6'b000000;
parameter op_lw =		6'b100011;
parameter op_sw = 	6'b101011;
parameter op_addi = 	6'b001000;

//Func constants
parameter func_and =	6'b100100;
parameter func_or =	6'b100101;
parameter func_nor =	6'b100111;
parameter func_xor =	6'b100110;
parameter func_add =	6'b10000x;
parameter func_sub=	6'b100010;

// wire constants
parameter high =		1'b1;
parameter low =		1'b0;
parameter select_a= 	1'b0;
parameter select_b=	1'b1;
parameter size_word=	2'b11;

always@(*)
begin
	case(opcode_in[5:0])
	op_arith:
		case (func_in[5:0])
		func_add:
			begin
			pc_enable_out = high;	
			instr_mux_select_out = select_b;
			regfile_we_out= high;
			alu_mux_select_out = select_a;
			alu_func_out = func_add;
			data_mem_re_out = low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = select_a;
			end
		func_sub:
			begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_a;
			regfile_we_out= high;
			alu_mux_select_out = select_a;
			alu_func_out = func_add;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = select_a;					
			end
		func_and:
			begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_b;
			regfile_we_out= high;
			alu_mux_select_out = select_b;
			alu_func_out = func_and;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = select_a;					
			end					
		func_or:
			begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_b;
			regfile_we_out= high;
			alu_mux_select_out = select_b;
			alu_func_out = func_or;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = select_a;					
			end
		func_nor:
			begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_b;
			regfile_we_out= high;
			alu_mux_select_out = select_b;
			alu_func_out = func_or;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = select_a;					
			end
		func_xor:
			begin
			pc_enable_out =	high;	
			instr_mux_select_out= select_a;
			regfile_we_out= high;
			alu_mux_select_out = select_a;
			alu_func_out = func_add;
			data_mem_re_out	= low;
			data_mem_we_out= low;
			data_mem_size_out = size_word;
			data_mem_mux_select_out = select_a;					
			end
		default: $display("Error in func_in"); 
		endcase
	op_addi:
		begin
		pc_enable_out =	high;	
		instr_mux_select_out= select_a;
		regfile_we_out= high;
		alu_mux_select_out = select_b;
		alu_func_out = func_add;
		data_mem_re_out	= low;
		data_mem_we_out= low;
		data_mem_size_out = size_word;
		data_mem_mux_select_out = select_a;					
		end
	op_lw:
		begin
		pc_enable_out =	high;	
		instr_mux_select_out= select_a;
		regfile_we_out= high;
		alu_mux_select_out = select_b;
		alu_func_out = func_add;
		data_mem_re_out	= high;
		data_mem_we_out= low;
		data_mem_size_out = size_word;
		data_mem_mux_select_out = select_b;					
		end
	op_sw:
		begin
		pc_enable_out =	high;	
		instr_mux_select_out= select_b;
		regfile_we_out= low;
		alu_mux_select_out = select_b;
		alu_func_out = func_add;
		data_mem_re_out	= low;
		data_mem_we_out= high;
		data_mem_size_out = size_word;
		data_mem_mux_select_out = select_b;					
		end
	default:  $display("Error in opconde_in"); 
	endcase
end
	
endmodule