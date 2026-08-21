module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  // Internal flip-flop signal
  logic Qold;

  // JK flip-flop logic
  always_ff @(posedge clk)
  begin
    Q = j ? 1'b0 : (k ? 1'b1 : Qold);
    Qold = Q;
  end

endmodule
