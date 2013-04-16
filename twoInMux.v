module twoInMux 
	#(parameter W=8)(input [W-1:0] a_in, input [W-1:0] b_in, output reg [W-1:0] mux_out, input select);

always@(*)
	begin
		case(select)
			1'b0:	mux_out = a_in;
			1'b1: mux_out = b_in;
		endcase
	end

endmodule