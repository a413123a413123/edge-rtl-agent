module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  // Combinational logic

  assign Q = j ? ~Q : k ? 1'b1 : Q;

endmodule
