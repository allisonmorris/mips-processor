`timescale 1ns/1ps

module leftShifter #(parameter W = 32, parameter N = 2) (input [W-1:0] _in, output reg [W-1:0] _out);

	always @(*) begin
		_out[W-1:N] <= _in[W-1:N];
		_out[N-1:0] <= {(N){1'b0}};
	end

endmodule