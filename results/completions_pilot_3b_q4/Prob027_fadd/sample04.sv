module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Combinational logic

  logic carry_1, carry_2;

  xor gate1 (carry_1, a, b);
  xor gate2 (sum, a, b, cin);
  and gate3 (carry_2, a, b);
  and gate4 (carry_2, a, cin);
  and gate5 (carry_2, b, cin);

  or gate6 (cout, carry_1, carry_2);

endmodule
