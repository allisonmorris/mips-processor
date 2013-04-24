`timescale 1ns/1ps

module adder (input [31:0] a_in, input [31:0] b_in, output reg [31:0] _out);

	always @(*) begin
		_out <= a_in + b_in;
	end

endmodule