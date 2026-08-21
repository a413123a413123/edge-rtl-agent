module TopModule
(
  input  logic in1,
  input  logic in2,
  input  logic in3,
  output logic out
);

  // Combinational logic

  logic temp;

  assign temp = in1 ^ in2; // Two-input XOR
  assign out = temp ^ in3;   // XOR with in3

endmodule
