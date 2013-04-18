module signExtend(input [15:0] i_in, output reg [31:0] extend_out);

always@(*)
	begin
		extend_out[15:0] <= i_in[15:0];
		if(i_in[15]==1'b1)
		begin
			extend_out[31:16] <= 16'hffff;
		end else begin
			extend_out[31:16] <= 16'h0000;
		end
	end
endmodule