module TopModule
(
  input  logic a,
  input  logic b,
  output logic sum,
  output logic cout
);

  // Combinational logic

  sum = a ^ b;
  cout = a & b;

endmodule
