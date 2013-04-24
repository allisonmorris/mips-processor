`timescale 1ns/1ps

module upShifter (input [15:0] _in, output reg [31:0] _out);

	always @(*) begin
		_out[15:0] <= 16'h0000;
		_out[31:16] <= _in[15:0];
	end

endmodule