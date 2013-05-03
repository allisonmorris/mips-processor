`timescale 1ns/1ps

module leftShifter #(parameter W = 32, parameter N = 2) (input [W-1:0] _in, output reg [W-1:0] _out);

	always @(*) begin
		/*_out[W-1:N] <= _in[W-N-1:0]; //31:2  29:0
		_out[N-1:0] <= {(N){1'b0}};  //1:0  00*/
		
		_out <= _in * 4;
	end

endmodule