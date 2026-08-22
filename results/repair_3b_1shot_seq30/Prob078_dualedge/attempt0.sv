module TopModule
(
  input  logic clk,
  input  logic d,
  output logic q
);

  // Synchronous logic

  always @(posedge clk or negedge clk) begin
    if (clk) begin
      q <= d;
    end
  end

endmodule
