module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  logic Qold;

  // Sequential logic

  always_ff @(posedge clk)
  begin
    Q = (j & ~k) | (~j & Qold);
  end

endmodule
