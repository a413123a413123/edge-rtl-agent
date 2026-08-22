module TopModule
(
  input  logic a,
  input  logic b,
  input  logic c,
  input  logic d,
  output logic out,
  output logic out_n
);

  // Intermediate wires
  logic and1, and2;

  // First layer AND gates
  and and_gate1 (and1, a, b);
  and and_gate2 (and2, c, d);

  // Second layer OR gate
  or or_gate (out, and1, and2);

  // Inverted output
  not not_gate (out_n, out);

endmodule
