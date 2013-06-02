module counter(clk,reset, pc_en,count);

input clk;
input reset;
input pc_en;
output [31:0] count;
wire clk;
wire reset;
wire pc_en;
reg [31:0] count;

always@(posedge clk)
	begin
		if(reset == 1'b1)
			begin
				count <= 0;
			end
		else if(pc_en == 1'b0)
			begin
				count <= count + 1;
			end
	end
endmodule