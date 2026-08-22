module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  // Flip-flop
  reg q_reg;

  // Sequential logic
  always @(posedge clk) begin
    if (a) begin
      q_reg <= b;
    end else begin
      q_reg <= q;
    end
  end

  // Observable output
  assign q = q_reg;
  assign state = q;

endmodule
