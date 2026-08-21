module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Priority encoder logic
  assign pos = in[7:4];

endmodule
