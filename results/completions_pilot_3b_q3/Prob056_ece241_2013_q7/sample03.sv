
  BEGIN

module TopModule(
  input clk in_

  input j in_
  input k in_
  output Q in_

  j := (input j >> 1) << 1
  out := (j >> k) << 1
endmodule

module[DONE]
