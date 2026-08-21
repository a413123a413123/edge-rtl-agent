module TopModule
(
  input  logic [2:0] in,
  output logic [1:0] out
);

  // Register to hold running count
  reg [1:0] count = 0;

  // Assign count based on each bit of in
  assign count[1] = in[2] | count[1]; // Add current bit to count
  assign count[0] = in[1] | count[0]; // Add current bit to count
  assign count[0] = in[0] | count[0]; // Add current bit to count

  // Assign output based on count
  assign out = count;

endmodule
