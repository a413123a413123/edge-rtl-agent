module TopModule
(
  input  logic [99:0] in,
  output logic [99:0] out
);

  // Combinational logic

  assign out = in [99:0];

endmodule
