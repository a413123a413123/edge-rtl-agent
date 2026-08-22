
TopModule(
  clk logic [1:1] in_,
  reset logic [1:1] out,


  reset_out = !reset;
  clk_out = clk & 1;
  if (reset_out) {
    reset_out = reset;

  end

endmodule
