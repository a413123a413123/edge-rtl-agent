module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic data,
  output logic [3:0] q
);

  // Sequential logic

  logic [3:0] q_reg;

  always @(posedge clk) begin
    if (shift_ena) begin
      q_reg <= {q_reg[2:0], data};
    end else if (count_ena) begin
      q_reg <= q_reg - 1;
    end
  end

  assign q = q_reg;

endmodule
