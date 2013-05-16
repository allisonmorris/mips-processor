module test_twoInMux();
	reg [7:0] a_in, b_in;
	reg select;
	wire [7:0] mux_out;
	
	twoInMux #(.W(8)) dut (.a_in(a_in), 
					.b_in(b_in),
					.mux_out(mux_out),
					.select(select)
				);
	initial
		begin
			
			select = 1'b0;
			a_in = 8'b0001101;
			b_in = 8'b1001100;
			#10
			select = 1'b1;
			a_in = 8'b0001101;
			b_in = 8'b1001100;
		end
				
	
endmodule