
module ExecuteModule (input clk, input reset, input [12:0] bundle_in, output [6:0] bundle_out,
		input [31:0] pc_seq_in, output [31:0] pc_seq_out, input [31:0] a_in, input [31:0] b_in,
		output [31:0] alu_out);

	wire [5:0] alu_func;	
	wire [12:0] bundle;
	wire [31:0] a, b;
	
	assign alu_func = bundle_in[12:7];
	assign bundle_out[6:0] = bundle[6:0];
		
	register #(.W(13)) controls (.clk(clk), .reset(reset), .enable(1'b1), .data_in(bundle_in), .q_out(bundle));
	register #(.W(32)) pc (.clk(clk), .reset(reset), .enable(1'b1), .data_in(pc_seq_in), .q_out(pc_seq_out));
	register #(.W(32)) reg_a (.clk(clk), .reset(reset), .enable(1'b1), .data_in(a_in), .q_out(a));
	register #(.W(32)) reg_b (.clk(clk), .reset(reset), .enable(1'b1), .data_in(b_in), .q_out(b));
	
	alu math (.Func_in(alu_func), .A_in(a), .B_in(b), .O_out(alu_out), .Branch_out(), 
		.Jump_out());

endmodule