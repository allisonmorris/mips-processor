module testCounter();
	reg clk;
	reg reset;
	reg pc_en;
	wire [31:0] cnt;

	initial
     	begin
      	  clk = 0;
      	  forever #10 clk = !clk;
     	end
	initial
		begin
			#20 reset = 0;
			#20 pc_en = 1;
			#20 reset = 1;
			#20 reset = 0;
			#20 pc_en = 0;
			#20 pc_en = 0;
			#20 pc_en = 0;
			#20 pc_en = 0;
			#20	pc_en = 1;
			#20 pc_en = 0;
			#20	pc_en = 1;			
		end
	
	counter dut(.clk(clk),.reset(reset),.pc_en(pc_en),.count(cnt));
		
endmodule