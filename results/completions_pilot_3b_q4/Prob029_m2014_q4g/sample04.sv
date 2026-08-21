module TopModule
(
  input  logic in1,
  input  logic in2,
  input  logic in3,
  output logic out
);

  // Combinational logic

  logic xnor_out;
  logic xor_out;

  // Connect xnor_out to in1 and in2
  assign xnor_out = in1 ^ in2;

  // Connect xor_out to in3 and xnor_out
  assign xor_out = in3 ^ xnor_out;

  // Assign out to xor_out
  assign out = xor_out;

endmodule
