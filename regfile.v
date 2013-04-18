`timescale 1ns / 1ps
module regfile(
	input clk,
	input reset, 
	input enable,
	input [4:0] readReg1_in, 
	input [4:0] readReg2_in, 
	input [4:0] writeReg_in,
	input [31:0] writeData_in, 
	output reg [31:0] data1_out, 
	output reg [31:0] data2_out); 
	
	reg [31:0] registers [31:0];
	
	always@(*)
	begin

		//registers[0] = 32'b0;
		data1_out = registers[readReg1_in];

		data2_out = registers[readReg2_in];
	end

	
	always@(posedge clk)
	begin
		if (reset) begin
			registers[0] = 32'd0;
			registers[1] = 32'd0;
			registers[2] = 32'd0;
			registers[3] = 32'd0;
			registers[4] = 32'd0;
			registers[5] = 32'd0;
			registers[6] = 32'd0;
			registers[7] = 32'd0;
			registers[8] = 32'd0;
			registers[9] = 32'd0;
			registers[10] = 32'd0;
			registers[11] = 32'd0;
			registers[12] = 32'd0;
			registers[13] = 32'd0;
			registers[14] = 32'd0;
			registers[15] = 32'd0;
			registers[16] = 32'd0;
			registers[17] = 32'd0;
			registers[18] = 32'd0;
			registers[19] = 32'd0;
			registers[20] = 32'd0;
			registers[21] = 32'd0;
			registers[22] = 32'd0;
			registers[23] = 32'd0;
			registers[24] = 32'd0;
			registers[25] = 32'd0;
			registers[26] = 32'd0;
			registers[27] = 32'd0;
			registers[28] = 32'd0;
			registers[29] = 32'd0;
			registers[31] = 32'd0;
			registers[32] = 32'd0;		
		end else begin 
			if(enable) 		//write is enabled
			begin
				 if(writeReg_in == 5'b00000)

					begin

						registers[0] = 32'd0;

					end

				else

					begin

						registers[writeReg_in] = writeData_in;

					end
			end
		end 

	end	
endmodule
