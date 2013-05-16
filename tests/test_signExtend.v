module test_signExtend ();

reg [15:0] i_in;
wire [31:0] extend_out;


// The design under test is our adder
   signExtend dut (   .i_in(i_in), 
   						.extend_out(extend_out)
             );
 // Test with a variety of inputs.
   // Introduce new stimulus on the falling clock edge so that values
   // will be on the input wires in plenty of time to be read by
   // registers on the subsequent rising clock edge.
   initial
     begin
        i_in = 16'b1111111111111111;
        #10
        i_in = 16'b0000011111111111;
     end // initial begin

endmodule
