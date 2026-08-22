module TopModule
(
  input  logic clk,
  input  logic reset,
  output logic [3:0] q
);

  // Sequential logic

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 4'b0;
    end else begin
      q <= q + 1;
    end
  end

endmodule
