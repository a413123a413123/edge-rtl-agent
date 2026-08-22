module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  logic reg q_reg;

  // Combinational logic
  assign q = q_reg;
  assign state = q;

  // Sequential logic
  always_ff @(posedge clk) begin
    q_reg <= a & b;
  end

endmodule
