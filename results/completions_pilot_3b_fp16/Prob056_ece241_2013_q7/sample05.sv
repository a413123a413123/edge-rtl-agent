module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  logic Qold;

  always_ff @(posedge clk) begin
    if (j)
      Q <= ~Qold;
    else if (k)
      Q <= 1'b0;
    else
      Q <= Qold;
  end

endmodule
