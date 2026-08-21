module TopModule (
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  reg state_reg;

  always @(posedge clk) begin
    if (a == b)
      state_reg = 0;
    else
      state_reg = 1;
  end

  assign q = state_reg;

endmodule
