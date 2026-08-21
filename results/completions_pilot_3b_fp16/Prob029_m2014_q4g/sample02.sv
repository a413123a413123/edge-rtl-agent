module TopModule
(
  input  logic in1,
  input  logic in2,
  input  logic in3,
  output logic out
);

  // Combinational logic

  logic xnor_result;
  logic xor_result;

  // XNOR gate
  assign xnor_result = (in1 == in2);

  // XOR gate
  assign xor_result = (xnor_result ^ in3);

  // Assign output
  assign out = xor_result;

endmodule
