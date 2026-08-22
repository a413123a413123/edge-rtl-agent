module TopModule
(
  input  logic a, b, c, d,
  output logic out
);

  // Combinational logic

  assign out = (a & ~b & c & d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d);

endmodule
