module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Sequential logic

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      z <= 1'b0; // Reset to zero
    end else if (x) begin
      z <= ~z; // Invert z on x=1
    end else begin
      z <= z; // Otherwise, keep z unchanged
    end
  end

endmodule
