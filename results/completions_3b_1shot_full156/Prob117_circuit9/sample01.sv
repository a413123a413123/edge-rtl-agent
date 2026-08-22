module TopModule
(
  input  logic clk,
  input  logic a,
  output logic [2:0] q
);

  always @(posedge clk) begin
    if (a) begin
      q <= q + 1;
    end else begin
      q <= 3'b0;
    end
  end

endmodule
