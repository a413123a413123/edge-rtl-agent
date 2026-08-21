module TopModule
(
  input  logic [2:0] in,
  output logic [1:0] out
);

  // Initialize count variable to 0
  logic [2:0] count = 3'b000;

  // Count the number of '1's in the input
  assign count = in & 1 | count;
  assign count = (in >> 1) & 1 | count;
  assign count = (in >> 2) & 1 | count;

  // Output the count as two bits
  assign out = count;

endmodule
