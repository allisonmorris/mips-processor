module signExtend(input [15:0] i_in, output [31:0] extend_out);

reg [31:0] extInstruct;
assign extend_out = extInstruct;

always@(*)
	begin
		extInstruct[15:0] = i_in[15:0];
		if(i_in[15]==1'b1)
		begin
			extInstruct[16] = i_in[15];
			extInstruct[17] = i_in[15];
			extInstruct[18] = i_in[15];
			extInstruct[19] = i_in[15];
			extInstruct[20] = i_in[15];
			extInstruct[21] = i_in[15];
			extInstruct[22] = i_in[15];
			extInstruct[23] = i_in[15];
			extInstruct[24] = i_in[15];
			extInstruct[25] = i_in[15];
			extInstruct[26] = i_in[15];
			extInstruct[27] = i_in[15];
			extInstruct[28] = i_in[15];
			extInstruct[29] = i_in[15];
			extInstruct[30] = i_in[15];
			extInstruct[31] = i_in[15];
		end
	end
endmodule