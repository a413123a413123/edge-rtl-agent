module TopModule (
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  logic reg q_reg;

  // Combinational logic
  assign q = q_reg;
  assign state = a & ~b;

  // Sequential logic
  always @(posedge clk) begin
    if (state) begin
      q_reg <= ~q_reg;
    end
  end

endmodule
