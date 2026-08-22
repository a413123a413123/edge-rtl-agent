module TopModule
(
  input  logic clk,
  input  logic w,
  input  logic R,
  input  logic E,
  input  logic L,
  output logic Q
);

  // Sequential logic

  always @(posedge clk) begin
    if (E) begin
      Q <= w;
    end else if (R) begin
      Q <= L;
    end else begin
      Q <= Q; // No change if neither E nor R is asserted
    end
  end

endmodule
