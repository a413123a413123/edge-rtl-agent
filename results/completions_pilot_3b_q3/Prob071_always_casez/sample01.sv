
[BEGIN
TopModule(
  input logic [7:0] in_

  output logic [7:0] out

  assign out = in_[0] & (in_ >> 1
  if (in_ >> 0) {
    out = in_[0] + 1
  else {
    out = 0
  }

endmodule
  [DONE]
