module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  logic a, b;

  // Asynchronous reset
  assign a = areset ? 1'b0 : a;
  assign b = areset ? 1'b1 : b;

  // Moore machine logic
  always @(posedge clk or posedge areset)
  begin
    if (areset)
      out <= 1'b0;
    else
      out <= b;
  end

endmodule
