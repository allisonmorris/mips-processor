
module ExecuteModule (input clk, input reset, input [13:0] bundle_in, output [7:0] bundle_out,
		input [31:0] pc_seq_in, output [31:0] pc_seq_out, input [31:0] a_in, input [31:0] b_in,
		input [4:0] reg_write_dest_in, output [4:0] reg_write_dest_out, input [31:0] reg_read2_in, output [31:0] reg_read2_out,
		output [31:0] alu_out);

	wire [5:0] alu_func;	
	wire [13:0] bundle;
	wire [31:0] a, b;
	
	assign alu_func = bundle_in[13:8];
	assign bundle_out[7:0] = bundle[7:0];
	
	register #(.W(5), .D(5'h00))  reg_write (.clk(clk), .reset(reset), .enable(1'b1), .data_in(reg_write_dest_in), .q_out(reg_write_dest_out));
	register #(.W(14), .D(14'h2531)) controls (.clk(clk), .reset(reset), .enable(1'b1), .data_in(bundle_in), .q_out(bundle));
	register #(.W(32)) pc (.clk(clk), .reset(reset), .enable(1'b1), .data_in(pc_seq_in), .q_out(pc_seq_out));
	register #(.W(32)) reg_a (.clk(clk), .reset(reset), .enable(1'b1), .data_in(a_in), .q_out(a));
	register #(.W(32)) reg_b (.clk(clk), .reset(reset), .enable(1'b1), .data_in(b_in), .q_out(b));
	register #(.W(32)) read2 (.clk(clk), .reset(reset), .enable(1'b1), .data_in(reg_read2_in), .q_out(reg_read2_out));
	
	alu math (.Func_in(alu_func), .A_in(a), .B_in(b), .O_out(alu_out), .Branch_out(), 
		.Jump_out());

endmodule