module test_regfile();

	reg clk;
	reg reset;
	reg enable;
	reg [4:0] readReg1_in;
	reg [4:0] readReg2_in;
	reg [4:0] writeReg_in;
	reg [31:0] writeData_in;
	wire [31:0] data1_out;
	wire [31:0] data2_out;
	
	regfile dut(.clk(clk), .reset(reset), .enable(enable), .readReg1_in(readReg1_in),
			.readReg2_in(readReg2_in), .writeReg_in(writeReg_in), .writeData_in(writeData_in),
			.data1_out(data1_out), .data2_out(data2_out));
			
	initial
     	begin
      	  clk = 0;
      	  forever #10 clk = !clk;
     	end
     
     initial
     	begin
     		enable = 1'b1;
     		reset = 1'b0;
     		writeReg_in = 5'b00000;
     		writeData_in = 32'd1;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b00001;
     		writeData_in = 32'd1;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b00010;
     		writeData_in = 32'd2;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b00011;
     		writeData_in = 32'd3;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b00100;
     		writeData_in = 32'd4;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b00101;
     		writeData_in = 32'd5;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b00110;
     		writeData_in = 32'd6;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b00111;
     		writeData_in = 32'd7;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01000;
     		writeData_in = 32'd8;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01001;
     		writeData_in = 32'd9;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01010;
     		writeData_in = 32'd10;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01011;
     		writeData_in = 32'd11;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01100;
     		writeData_in = 32'd12;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01101;
     		writeData_in = 32'd13;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01110;
     		writeData_in = 32'd14;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b01111;
     		writeData_in = 32'd15;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10000;
     		writeData_in = 32'd16;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10001;
     		writeData_in = 32'd17;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10010;
     		writeData_in = 32'd18;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10011;
     		writeData_in = 32'd19;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10100;
     		writeData_in = 32'd20;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10101;
     		writeData_in = 32'd21;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10110;
     		writeData_in = 32'd22;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b10111;
     		writeData_in = 32'd23;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11000;
     		writeData_in = 32'd24;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11001;
     		writeData_in = 32'd25;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11010;
     		writeData_in = 32'd26;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11011;
     		writeData_in = 32'd27;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11100;
     		writeData_in = 32'd28;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11101;
     		writeData_in = 32'd29;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11110;
     		writeData_in = 32'd30;
     		@(negedge clk);
     		#10
     		writeReg_in = 5'b11111;
     		writeData_in = 32'd31;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd0;
     		readReg2_in = 5'd1;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd2;
     		readReg2_in = 5'd3;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd4;
     		readReg2_in = 5'd5;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd6;
     		readReg2_in = 5'd7;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd8;
     		readReg2_in = 5'd9;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd10;
     		readReg2_in = 5'd11;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd12;
     		readReg2_in = 5'd13;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd14;
     		readReg2_in = 5'd15;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd16;
     		readReg2_in = 5'd17;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd18;
     		readReg2_in = 5'd19;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd20;
     		readReg2_in = 5'd21;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd22;
     		readReg2_in = 5'd23;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd24;
     		readReg2_in = 5'd25;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd26;
     		readReg2_in = 5'd27;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd28;
     		readReg2_in = 5'd29;
     		@(negedge clk);
     		#10
     		readReg1_in = 5'd30;
     		readReg2_in = 5'd31;
     		@(negedge clk);
     		
     	end
endmodule