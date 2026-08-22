module TopModule
(
  input  logic clk,
  input  logic d,
  output logic q
);

  always @(posedge clk or negedge clk) begin
    q <= d;
  end

endmodule
