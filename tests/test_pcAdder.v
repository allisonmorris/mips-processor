module test_pcAdder();
	
	reg [31:0] data_in;
	wire [31:0] pc_out;
	
	pcAdder dut(.data_in(data_in), .pc_out(pc_out));
	
	initial
		begin
			data_in = 32'h0004 	;
			#10
			data_in = 32'h0008 	;
			#10
			data_in = 32'h000a 	;
		end
		

endmodule