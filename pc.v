module pc(input clk, input reset, input [31:0] data_in, output reg [31:0] q_out, input enable);

always@(posedge clk)
	begin
		if(enable)
			begin	
				if(~reset)
					begin
						q_out <= data_in;
					end
				else
					begin
						q_out <= 1'b0;
					end
			end
	end

endmodule