module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic [3:0] data,
  output logic [3:0] q
);

  // Sequential logic

  always_ff @(posedge clk) begin
    if (shift_ena) begin
      q <= data;
    end else if (count_ena) begin
      q <= q - 1;
    end
  end

endmodule
