module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  // Flip-flop for memory
  reg state_reg;

  // Combinational logic
  assign q = a | b;
  assign state_reg = q;

  // Sequential logic
  always_ff @(posedge clk) begin
    state = state_reg;
  end

endmodule
