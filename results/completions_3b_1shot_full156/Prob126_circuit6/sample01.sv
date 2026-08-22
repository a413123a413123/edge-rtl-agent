module TopModule
(
  input  logic [2:0] a,
  output logic [15:0] q
);

  // Combinational logic

  assign q = {a, a, a, a, a, a, a, a, a, a, a, a, a, a, a};

endmodule
