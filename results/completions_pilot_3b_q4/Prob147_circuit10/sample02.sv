module TopModule (
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  // Flip-flop
  reg q_reg;

  // Combinational logic
  always @ (posedge clk) begin
    q_reg <= a & b;
  end

  assign q = q_reg;
  assign state = a | b;

endmodule
