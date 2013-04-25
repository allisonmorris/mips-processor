module unsignExtend #(parameter W = 16)(input [W-1:0] i_in, output reg [31:0] extend_out);

always@(*)
	begin
		extend_out[W-1:0] <= i_in[W-1:0];
			extend_out[31:W] <= {(32-W){1'b0}};
	end
endmodule