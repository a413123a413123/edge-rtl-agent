
TopModule(
  clk logic [1:1] clk

  reset logic [1:0] reset

  d logic [7:0] d
  q logic [7:0] q

  // Combinational logic


  clk.next { // active high
  reset { // reset to zero
  d.next { // set q to 0

endmodule
