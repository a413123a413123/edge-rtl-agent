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

  assign q = (a == 0) ? (b == 0) ? (c == 0) ? (d == 0) ? (e == 0) ? 0 : 1 : 2 : 3 : 4 : 5 : 6 : 7 : 8 : 9 : 10 : 11 : 12 : 13 : 14 : 15;

endmodule
