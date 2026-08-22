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
    if (R) begin
      Q <= w;
    end else if (E) begin
      Q <= w;
    end else if (L) begin
      Q <= Q;
    end
  end

endmodule
