module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  // Combinational logic

  logic Qold;

  assign Qold = Q;
  assign Q = j ^ (k & ~Qold);

endmodule
