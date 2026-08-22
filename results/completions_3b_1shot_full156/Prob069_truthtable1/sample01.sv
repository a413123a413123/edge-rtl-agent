module TopModule
(
  input  logic x3,
  input  logic x2,
  input  logic x1,
  output logic f
);

  // Combinational logic

  assign f = x3 | x2 | x1;

endmodule
