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
		if(enable) 		//write is enabled
		begin
			 if(writeReg_in == 5'b00000)

				begin

					registers[0] = 1'b0;

				end

			else

				begin

					registers[writeReg_in] = writeData_in;

				end
		end

	end	
endmodule
