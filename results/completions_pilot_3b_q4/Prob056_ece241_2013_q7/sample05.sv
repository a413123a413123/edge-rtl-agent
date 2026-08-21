module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  // Sequential logic

  always_ff @(posedge clk) begin
    Q = j | (~k & Qold);
  end

  // Initial value for Q
  initial Q = 1'b0;

  // Internal signal for Qold
  reg Qold = 1'b0;

endmodule
