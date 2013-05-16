module testPC();
	reg clk;
	reg reset;
	reg enable;
	wire [31:0] q_out;
	reg [31:0] data_in;
	
	pc dut (.clk(clk), .reset(reset), .data_in(data_in), .q_out(q_out), .enable(enable));

	initial
     	begin
      	  clk = 0;
      	  forever #10 clk = !clk;
     	end
     
     initial
     	begin
     		enable = 1'b1;
     		reset = 1'b0;
     		data_in = 32'hf732;
     		@(negedge clk);
     		enable = 1'b1;
     		reset = 1'b0;
     		data_in = 32'hA333;
     		@(negedge clk);
     	end
     
endmodule