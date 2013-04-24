module fourInMux 
	#(parameter W=8)(input [W-1:0] a_in, input [W-1:0] b_in, input [W-1:0] c_in, 
	input [W-1:0] d_in, output reg [W-1:0] mux_out, input [1:0] select);

always@(*)
	begin
		case(select)
			2'b00: mux_out <= a_in;
			2'b01: mux_out <= b_in;
			2'b10: mux_out <= c_in;
			2'b11: mux_out <= d_in;
		endcase
	end

endmodule