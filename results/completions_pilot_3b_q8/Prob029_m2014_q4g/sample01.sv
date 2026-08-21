module TopModule
(
  input  logic in1,
  input  logic in2,
  input  logic in3,
  output logic out
);

  // Combinational logic

  wire xnor_out;
  wire xor_out;

  // XNOR gate
  assign xnor_out = in1 ^ in2;

  // XOR gate
  assign xor_out = xnor_out ^ in3;

  // Assigning output
  assign out = xor_out;

endmodule
