module TopModule
(
  input  logic [3:0] a,
  input  logic [3:0] b,
  input  logic [3:0] c,
  input  logic [3:0] d,
  input  logic [3:0] e,
  output logic [3:0] q
);

  // Combinational logic

  assign q = (a == b) ? d : (a == c) ? e : (a == d) ? f : (a == e) ? f : (a == f) ? f : d;

endmodule
