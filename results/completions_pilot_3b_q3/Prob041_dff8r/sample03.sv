
module TopModule(
  clk [8:0] in_,
  reset [8:0] out,

  input d [8:0] in_,
  output q [8:0] out

  // DFF logic
  d_ff0 = clk | 1
  d_ff1 = d_ff0
  output q = ! d_ff1

endmodule
