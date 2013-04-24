`timescale 1ns/1ps

module dataMemoryLoader (input [31:0] _in, input [1:0] size_in, input signed_in, output reg [31:0] _out);

	localparam WORD = 2'b11;
	localparam HALF = 2'b01;
	localparam BYTE = 2'b00;

	always @(*) begin
		case (size_in) 
			WORD: begin
				_out <= _in;
			end
			HALF: begin
				_out[15:0] <= _in[15:0];
				if (signed_in == 1'b1) begin
					if (_in[15] == 1'b1) begin
						_out[31:16] <= 16'hffff;
					end else begin
						_out[31:16] <= 16'h0000;
					end
				end else begin
					_out[31:16] <= 16'h0000;
				end
			end
			BYTE: begin
				_out[7:0] <= _in[7:0];
				if (signed_in == 1'b1) begin
					if (_in[7] == 1'b1) begin
						_out[31:8] <= 24'hffffff;
					end else begin
						_out[31:8] <= 24'h000000;
					end
				end else begin
					_out[31:8] <= 24'h000000;
				end
			end
			default: begin
				_out <= _in;
			end
		endcase
	end

endmodule