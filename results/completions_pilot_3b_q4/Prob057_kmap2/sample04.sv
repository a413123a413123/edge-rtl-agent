module TopModule
(
  input  logic a, b, c, d,
  output logic out
);

  assign out = ~(a & b) & (c | d);

endmodule
