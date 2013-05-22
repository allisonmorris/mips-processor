module pcAdder ( input [31:0] data_in, output [31:0] pc_out);

assign pc_out = data_in + 32'h0004;

endmodule