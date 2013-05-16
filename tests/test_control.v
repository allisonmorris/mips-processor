`timescale 1ns/1ps

module test_control();
	reg [5:0] opcode_in;
	reg [5:0] func_in;
	wire pc_enable_out;
	wire instr_mux_select_out;
	wire regfile_we_out;
	wire alu_mux_select_out;
	wire [5:0] alu_func_out;
	wire data_mem_re_out;
	wire data_mem_we_out;
	wire data_mem_mux_select_out;
	wire [1:0] data_mem_size_out;
	
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
	parameter func_add =	6'b100000;
	parameter func_sub=	6'b100010;


	control dut(.opcode_in(opcode_in),.func_in(func_in), .pc_enable_out(pc_enable_out), .instr_mux_select_out(instr_mux_select_out),
		.regfile_we_out(regfile_we_out), .alu_mux_select_out(alu_mux_select_out), .alu_func_out(alu_func_out), .data_mem_re_out(data_mem_re_out),
		.data_mem_we_out(data_mem_we_out), .data_mem_mux_select_out(data_mem_mux_select_out), .data_mem_size_out(data_mem_size_out)
		);
	
	initial
		begin
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
			opcode_in = op_addi;
			func_in = func_add;
			#10
			opcode_in = op_lw;
			func_in = func_add;
			#10
			opcode_in = op_sw;
			func_in = func_add;
			#10
			opcode_in = 6'b111111;
			func_in = 6'b111111;
		end
endmodule