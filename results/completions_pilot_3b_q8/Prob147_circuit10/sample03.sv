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

  // Sequential logic
  always @(posedge clk) begin
    if (a) begin
      if (b) begin
        q_reg <= 1'b1;
      end else begin
        q_reg <= 1'b0;
      end
    end else if (b) begin
      q_reg <= 1'b0;
    end else begin
      q_reg <= 1'b0;
    end
  end

endmodule
