module pc(input clk, input reset, input [31:0] data_in, output reg [31:0] q_out, input enable);

always@(posedge clk)
	if (reset == 1'b1) begin
		q_out <= 32'h003ffffc;
	end else begin
		if (enable == 1'b1) begin
			q_out <= data_in;
		end else begin
			q_out <= q_out;
		end
	end

endmodule