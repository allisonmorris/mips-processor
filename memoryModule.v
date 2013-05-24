
module MemoryModule (
	input clk, 
	input reset, 
	input [7:0] bundle_in, 
	input [31:0] address_in, 
	input [31:0] reg_b_in, 
	input [4:0] write_reg_in,
	output [4:0] write_reg_out,
	output [1:0] bundle_out,
	input [31:0] pc_seq_in, 
	output [31:0] pc_seq_out, 
	output [31:0] skip_ram_mux_out,
	input [7:0] serial_in,
	input serial_valid_in,
	input serial_ready_in,
	output [7:0] serial_out,
	output serial_rden_out,
	output serial_wren_out);
	
	
	wire skip_ram_mux_sel,
		  ram_data_signed, 
		  ram_read_en, 
		  ram_write_en;
	wire [1:0] ram_data_size; 
	wire [7:0] bundle;
	wire [31:0] mem_loader_out, address, reg_b, data_mem_out;
	
	//Assign bundle bits to wires
	assign skip_ram_mux_sel = bundle[7];
	assign ram_data_size = bundle[5:4];
	assign ram_data_signed = bundle[6];
	assign ram_read_en = bundle[2];
	assign ram_write_en = bundle[3];
	assign bundle_out[1:0] = bundle[1:0];
	
	// data mem paths
	parameter ram_mem0_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab4/hello_world.data_ram0.memh";
	parameter ram_mem1_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab4/hello_world.data_ram1.memh";
	parameter ram_mem2_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab4/hello_world.data_ram2.memh";
	parameter ram_mem3_path = "C:/Alex/Documents/cse141/mips-processor/mem/lab4/hello_world.data_ram3.memh";
		
	//Registers for Inputs
	register #(.W(8), .D(8'h31)) controls (.clk(clk), .reset(reset), .enable(1'b1), .data_in(bundle_in), .q_out(bundle));
	register #(.W(32)) pc (.clk(clk), .reset(reset), .enable(1'b1), .data_in(pc_seq_in), .q_out(pc_seq_out));
	register #(.W(32)) address_reg (.clk(clk), .reset(reset), .enable(1'b1), .data_in(address_in), .q_out(address));
	register #(.W(32)) register_b (.clk(clk), .reset(reset), .enable(1'b1), .data_in(reg_b_in), .q_out(reg_b));
	register #(.W(5), .D(5'h00)) wr (.clk(clk), .reset(reset), .enable(1'b1), .data_in(write_reg_in), .q_out(write_reg_out));
	
	//Data memory mux POST-ALU
	twoInMux#(.W(32)) dataMemMux (.a_in(address), .b_in(mem_loader_out), .mux_out(skip_ram_mux_out), 
		.select(skip_ram_mux_sel)); 
		
	dataMemoryLoader dmloader (._in(data_mem_out), .size_in(ram_data_size), .signed_in(ram_data_signed), 
		._out(mem_loader_out), .offset_in(address[1:0]));
	
	//Data Memory
	data_memory
	#(.INIT_PROGRAM0(ram_mem0_path),
		.INIT_PROGRAM1(ram_mem1_path),
		.INIT_PROGRAM2(ram_mem2_path),
		.INIT_PROGRAM3(ram_mem3_path))
		ram (.clock(clk), .reset(reset), .addr_in(address), 
		.writedata_in(reg_b), .we_in(ram_write_en),.readdata_out(data_mem_out),
		.re_in(ram_read_en), .size_in(ram_data_size), 
		.serial_in(serial_in), .serial_ready_in(serial_ready_in), .serial_valid_in(serial_valid_in), 
		.serial_out(serial_out), .serial_rden_out(serial_rden_out), .serial_wren_out(serial_wren_out));


endmodule