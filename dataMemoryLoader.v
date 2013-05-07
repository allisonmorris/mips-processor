`timescale 1ns/1ps

module dataMemoryLoader (input [31:0] _in, input [1:0] offset_in, input [1:0] size_in, input signed_in, output reg [31:0] _out);

	localparam WORD = 2'b11;
	localparam HALF = 2'b01;
	localparam BYTE = 2'b00;
	
	reg sign;

	always @(*) begin
		case (size_in) 
			WORD: begin
				_out <= _in;
				sign <= _in[31];
			end
			HALF: begin
				if (offset_in == 2'b10) begin
					_out[15:0] <= _in[31:16];
					sign <= _in[31];
				end else begin
					_out[15:0] <= _in[15:0];
					sign <= _in[15];
				end
				if (signed_in == 1'b0) begin
					if (sign == 1'b1) begin
						_out[31:16] <= 16'hffff;
					end else begin
						_out[31:16] <= 16'h0000;
					end
				end else begin
					_out[31:16] <= 16'h0000;
				end
			end
			BYTE: begin
				case (offset_in) 
					2'b00: begin
						_out[7:0] <= _in[7:0];
						sign <= _in[7];
					end
					2'b01: begin
						_out[7:0] <= _in[15:8];
						sign <= _in[15];
					end
					2'b10: begin
						_out[7:0] <= _in[23:16];
						sign <= _in[23];
					end
					2'b11: begin
						_out[7:0] <= _in[31:24];
						sign <= _in[31];
					end
				endcase
				if (signed_in == 1'b0) begin
					if (sign == 1'b1) begin
						_out[31:8] <= 24'hffffff;
					end else begin
						_out[31:8] <= 24'h000000;
					end
				end else begin
					_out[31:8] <= 24'h000000;
				end
			end
			default: begin
				sign = 1'b0;
				_out <= _in;
			end
		endcase
	end

endmodule