module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  logic Q_old;

  always_ff @(posedge clk) begin
    if (j && !k)
      Q = 1'b1;
    else if (j && k)
      Q = ~Q_old;
    else
      Q = Q_old;
  end

  assign Q_old = Q;

endmodule
