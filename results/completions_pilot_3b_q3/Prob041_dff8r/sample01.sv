
[BEGIN
module

TopModule(
  clk => in_clk
  reset => in_reset

  d => in_d
  q => out_q
  // Combinational logic

  if (in_clk) {
    out_q = in_d;
  } else {
    out_q = ;0;
  }
endmodule[DONE]
