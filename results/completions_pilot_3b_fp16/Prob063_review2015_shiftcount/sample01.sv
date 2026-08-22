module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic data,
  output logic [3:0] q
);

  // Sequential logic

  logic [3:0] shift_reg;

  always_ff @(posedge clk) begin
    if (shift_ena) begin
      shift_reg <= {data, shift_reg[3:1]};
    end else if (count_ena) begin
      shift_reg <= shift_reg - 1;
    end
  end

  assign q = shift_reg;

endmodule
