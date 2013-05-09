module test_shiftby2();

reg [31:0] in;
wire [31:0] out;

shiftby2 dut(.in(in),.out(out));

initial
	begin
		in = 32'h000f;
	end
	
endmodule