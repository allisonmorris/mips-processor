`timescale 1ns/1ps

module control(
	input [5:0] opcode_in,
	output pc_en_out
	);

	assign pc_en_out = 1'b1;
	
endmodule