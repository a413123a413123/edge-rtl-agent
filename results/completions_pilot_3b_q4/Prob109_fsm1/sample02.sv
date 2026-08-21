module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  logic a, b;

  always_ff @(posedge clk, posedge areset)
  begin
    if (areset) begin
      a <= 1'b0;
      b <= 1'b1;
    end else begin
      a <= in;
      b <= a;
    end
  end

  assign out = a;

endmodule
