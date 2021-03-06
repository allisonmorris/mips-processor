`timescale 1ns/1ps

module concatenator #(parameter UP = 4, parameter W = 32)
	(input [W-1:0] a_in, input [W-1:0] b_in, output reg [W-1:0] _out);
	
	always @(*) begin
		_out[W-1:W-UP] <= a_in[W-1:W-UP];
		_out[W-UP-1:0] <= b_in[W-UP-1:0];
	end
	
endmodule