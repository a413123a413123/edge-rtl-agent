module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  // D flip-flop
  reg [0:0] state_reg;

  // Combinational logic
  assign q = (a & b) | (~a & ~b) | (a & ~b & state_reg);

  // Sequential logic
  always @(posedge clk) begin
    state_reg <= q;
  end

endmodule
