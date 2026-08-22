module TopModule
(
  input  logic [99:0] in,
  output logic out_and,
  output logic out_or,
  output logic out_xor
);

  // Combinational logic

  assign out_and = in & in[99:0];
  assign out_or  = in | in[99:0];
  assign out_xor = in ^ in[99:0];

endmodule
