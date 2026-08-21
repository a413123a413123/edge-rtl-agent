module TopModule
(
  input  logic in1,
  input  logic in2,
  input  logic in3,
  output logic out
);

  // Combinational logic

  logic xnor_output;
  logic xor_output;

  // XNOR gate
  assign xnor_output = in1 ^ in2;

  // XOR gate
  assign xor_output = xnor_output ^ in3;

  // Assign XOR output to the output port
  assign out = xor_output;

endmodule
