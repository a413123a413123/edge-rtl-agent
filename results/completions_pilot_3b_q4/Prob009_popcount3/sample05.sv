module TopModule
(
  input  logic [2:0] in,
  output logic [1:0] out
);

  // Count the number of '1's in the input
  assign out = |in;

endmodule
