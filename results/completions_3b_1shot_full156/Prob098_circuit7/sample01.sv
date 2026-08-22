module TopModule
(
  input  logic clk,
  input  logic a,
  output logic q
);

  reg q_reg;

  always @(posedge clk) begin
    q_reg <= a;
  end

  assign q = q_reg;

endmodule
