module signExtend #(parameter W = 16)(input [W-1:0] i_in, output reg [31:0] extend_out);

always@(*)
	begin
		extend_out[W-1:0] <= i_in[W-1:0];
		if(i_in[W-1]==1'b1)
		begin
			extend_out[31:W] <= {(32-W){1'b1}};
		end else begin
			extend_out[31:W] <= {(32-W){1'b0}};
		end
	end
endmodule