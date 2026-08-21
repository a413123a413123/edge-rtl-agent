module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  logic Qold;

  always_ff @(posedge clk)
  begin
    Qold = Q;
    if (j == 1)
      Q = 1'b1;
    else if (k == 1)
      Q = 1'b0;
    else
      Q = Qold;
  end

endmodule
