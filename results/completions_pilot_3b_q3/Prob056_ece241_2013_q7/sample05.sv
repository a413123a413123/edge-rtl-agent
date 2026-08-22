
[BEGIN
module
module module TopModule (
  input clk in_,  input j in_,  input k in_, output Q out_,
  output Qold out_

  // Combinational logic

  var Qold = j ^ input k;
  var Q = (Qold >> 1

  var out = (Q ^ clk);

endmodule module[DONE]
