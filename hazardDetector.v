
module hazardDetector (input clk, input reset, input [31:0] instr_in, output reg stall_out);

	reg [4:0] reg_dest [2:0];
	
	wire [5:0] instr_opcode;
	wire [4:0] instr_rs, instr_rt, instr_rd;
	
	assign instr_opcode = instr_in[31:26];
	assign instr_rs = instr_in[25:21];
	assign instr_rt = instr_in[20:16];
	assign instr_rd = instr_in[15:11];
	
	parameter zero = 5'b00000;
	parameter ra = 5'b11111;
	parameter yes = 1'b1;
	parameter no = 1'b0;
	
	// 001    use rs as source and rt as dest X
	// 100    use rs as source and rt as dest X
	// 000011 uses 31 as dest X
	
	// 00011  use rs as source X
	// 000001 use rs as source X
	// 1010   use rs and rt as source X
	// 00010  use rs and rt as source X
	// 000000 use rs and rt as source and rd as dest X

	always @(posedge clk) begin
		if (reset) begin
			reg_dest[2] <= 5'b00000;
			reg_dest[1] <= 5'b00000;
			reg_dest[0] <= 5'b00000;
			stall_out <= 1'b0;
		end else begin
			// move stages along
			reg_dest[2] <= reg_dest[1];
			reg_dest[1] <= reg_dest[0];
			
			// handle immediate modifiers: read rs, write rt
			if ((instr_opcode[5:3] == 3'b001) || (instr_opcode[5:3] == 3'b100)) begin
				if (instr_rs == zero) begin
					reg_dest[0] <= instr_rt;
					stall_out <= no;
				end else if ((reg_dest[0] == instr_rs) || (reg_dest[1] == instr_rs)) begin
					reg_dest[0] <= zero;
					stall_out <= yes;
				end else begin
					reg_dest[0] <= instr_rt;
					stall_out <= no;
				end
			// handle single register jumps/branches: read rs
			end else if ((instr_opcode[5:1] == 5'b00011) || (instr_opcode[5:0] == 6'b000001)) begin
				reg_dest[0] <= zero;
				if (instr_rs == zero) begin
					stall_out <= no;
				end else if ((reg_dest[0] == instr_rs) || (reg_dest[1] == instr_rs)) begin
					stall_out <= yes;
				end else begin
					stall_out <= no;
				end
			// handle double readers: read rs and rt
			end else if ((instr_in[5:2] == 4'b1010) || (instr_in[5:1] == 5'b00010)) begin
				reg_dest[0] <= zero;
				if ((instr_rs == zero) && (instr_rt == zero)) begin
					stall_out <= no;
				end else if ((reg_dest[0] == instr_rs) || (reg_dest[1] == instr_rs) || (reg_dest[0] == instr_rt) || (reg_dest[1] == instr_rt)) begin
					stall_out <= yes;
				end else begin
					stall_out <= no;
				end
			// handle double reader and solo writers: read rs and rt, write rd
			end else if (instr_in[5:0] == 6'b000000) begin
				if ((instr_rs == zero) && (instr_rt == zero)) begin
					reg_dest[0] <= instr_rd;
					stall_out <= no;
				end else if ((reg_dest[0] == instr_rs) || (reg_dest[1] == instr_rs) || (reg_dest[0] == instr_rt) || (reg_dest[1] == instr_rt)) begin
					reg_dest[0] <= zero;
					stall_out <= yes;
				end else begin
					reg_dest[0] <= instr_rd;
					stall_out <= no;
				end
			// handle jal write only: write 31
			end else if (instr_in[5:0] == 6'b000011) begin
				reg_dest[0] <= ra;
				stall_out <= no;
			// handle default: should be nothing
			end else begin
				reg_dest[0] <= zero;
				stall_out <= no;
			end
		end
	end
	
	/*always @(posedge clk) begin
		if (reset) begin
			reg_dest[4] <= 5'b00000;
			reg_dest[3] <= 5'b00000;
			reg_dest[2] <= 5'b00000;
			reg_dest[1] <= 5'b00000;
			reg_dest[0] <= 5'b00000;
			stall_out <= 1'b0;
		end else begin
			reg_dest[4] <= reg_dest[3];
			reg_dest[3] <= reg_dest[2];
			reg_dest[2] <= reg_dest[1];
			reg_dest[1] <= reg_dest[0];
			
			if ((instr_opcode[5:3] == 3'b001) || (instr_opcode[5:3] == 3'b100)) begin
				if (instr_rt == zero) begin
					stall_out <= no;
					reg_dest[0] <= zero;
				end else begin
					if (reg_dest[1] == instr_rt) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else if (reg_dest[2] == instr_rt) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else if (reg_dest[3] == instr_rt) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else if (reg_dest[4] == instr_rt) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else begin
						stall_out <= no;
						reg_dest[0] <= instr_rt;
					end
				end
			end else if (instr_opcode[5:0] == 6'b000000) begin
				reg_dest[0] <= instr_rd;
				if (instr_rd == zero) begin
					stall_out <= no;
					reg_dest[0] <= zero;
				end else begin
					if (reg_dest[1] == instr_rd) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else if (reg_dest[2] == instr_rd) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else if (reg_dest[3] == instr_rd) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else if (reg_dest[4] == instr_rd) begin
						stall_out <= yes;
						reg_dest[0] <= zero;
					end else begin
						stall_out <= no;
						reg_dest[0] <= instr_rd;
					end
				end
			end else if (instr_opcode[5:0] == 6'b000011) begin
				reg_dest[0] <= ra;
				if (reg_dest[1] == ra) begin
					stall_out <= yes;
					reg_dest[0] <= zero;
				end else if (reg_dest[2] == ra) begin
					stall_out <= yes;
					reg_dest[0] <= zero;
				end else if (reg_dest[3] == ra) begin
					stall_out <= yes;
					reg_dest[0] <= zero;
				end else if (reg_dest[4] == ra) begin
					stall_out <= yes;
					reg_dest[0] <= zero;
				end else begin
					stall_out <= no;
					reg_dest[0] <= ra;
				end
			end else begin
				reg_dest[0] <= zero;
				stall_out <= no;
			end
		end
	end*/

endmodule