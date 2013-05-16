module register #(parameter W = 32, parameter D = 0)(input clk, input reset, input [W-1:0] data_in, 
		output reg [W-1:0] q_out, input enable);

always@(posedge clk)
	if (reset == 1'b1) begin
		q_out <= D;
	end else begin
		if (enable == 1'b1) begin
			q_out <= data_in;
		end else begin
			q_out <= q_out;
		end
	end

endmodule