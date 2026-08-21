module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  reg state_reg;

  // Sequential logic
  always_ff @(posedge clk) begin
    if (a) begin
      if (b) begin
        state_reg <= 1;
      end else begin
        state_reg <= 0;
      end
    end else begin
      state_reg <= 0;
    end
  end

  // Combinational logic
  assign q = state_reg;

endmodule
