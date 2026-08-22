
module TopModule(
  clk, a, b

  out_assign = a | b;
  out_always_comb = @a | @b;
  out_always_ff = @a | @b | clk;

endmodule
