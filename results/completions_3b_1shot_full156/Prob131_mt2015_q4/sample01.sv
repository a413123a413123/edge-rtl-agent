module TopModule
(
  input  logic x,
  input  logic y,
  output logic z
);

  // Instantiate A and B submodules
  A a1 (x, y);
  A a2 (x, y);
  B b1 (x, y);
  B b2 (x, y);

  // Connect outputs of A submodules to OR gate
  wire a1_out = a1.z;
  wire a2_out = a2.z;
  wire or_out = a1_out | a2_out;

  // Connect outputs of B submodules to AND gate
  wire b1_out = b1.z;
  wire b2_out = b2.z;
  wire and_out = b1_out & b2_out;

  // Connect outputs of OR and AND gates to XOR gate
  wire xor_out = or_out ^ and_out;

  // Assign XOR output to z
  assign z = xor_out;

endmodule

module A
(
  input  logic x,
  input  logic y,
  output logic z
);

  // Combinational logic
  assign z = x ^ y;

endmodule

module B
(
  input  logic x,
  input  logic y,
  output logic z
);

  // Combinational logic
  assign z = x & y;

endmodule
