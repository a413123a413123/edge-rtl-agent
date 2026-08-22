module TopModule
(
  input  logic clk,
  input  logic d,
  input  logic r,
  output logic q
);

  // D flip flop with active high synchronous reset

  always @(posedge clk or posedge r) begin
    if (r) begin
      q <= 1'b0;
    end else begin
      q <= d;
    end
  end

endmodule
