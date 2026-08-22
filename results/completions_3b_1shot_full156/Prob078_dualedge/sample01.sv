module TopModule
(
  input  logic clk,
  input  logic d,
  output logic q
);

  // Flip-flop logic

  reg q_reg;

  always @(posedge clk or negedge clk) begin
    if (clk) begin
      q_reg <= d;
    end else begin
      q_reg <= q_reg;
    end
  end

  assign q = q_reg;

endmodule
