
[BEGIN
module
TopModule(
  input clk  clk

  input j  j
  input k k
  output Q qold

  assign Qold = (clk & k) + (j & ~k)

endmodule[DONE]
