module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Combinational logic

  logic s, c;

  or #1.0 (s, a, b, cin);
  and #1.0 (c, a, b);
  and #1.0 (c, a, cin);
  and #1.0 (c, b, cin);
  or #1.0 (cout, c);

  assign sum = s;

endmodule
