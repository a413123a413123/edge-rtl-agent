module TopModule
(
  input  logic [2:0] in,
  output logic [1:0] out
);

  // Register to hold running count
  reg [1:0] count = 0;

  // Assign count based on each bit of input
  assign count[1] = in[2] | count[1]; // Bit 2
  assign count[0] = in[1] | count[0]; // Bit 1
  assign count[0] = in[0] | count[0]; // Bit 0

  // Output the count
  assign out = count;

endmodule
