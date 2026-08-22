
[BEGIN
module
module: TopModule {
  clk logic [8:0] clk

  resetn logic [8:0] resetn
  in logic [8:0] in_
  out logic [8:0] out

  // Sequential logic

  out = in_ ^ (resetn ^ (in & !clk) | clk)

endmodule[DONE]
