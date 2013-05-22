`timescale 1ns/1ps

module shiftby2 (input [31:0] in, output [31:0] out);

reg [31:0] temp;

assign out = temp;

always@(*)
	begin
		temp = in << 2;
	end

endmodule