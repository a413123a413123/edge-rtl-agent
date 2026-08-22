
module TopModule {
  public input: (Bit) clk, reset: Bit, x: Bit

  public output: Bit

  bit_t0 = x ^ (!x)

  if (clk === 1) {
    z = 1
  } else {
    z = 0
  }

  output = z

endmodule
