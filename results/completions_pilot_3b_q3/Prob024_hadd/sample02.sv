
[BEGIN

TopModule(
  in input [7:0] a,

  in bit [7:0] b
  out sum [7:0] cout

  half_add = (in & b).to0

endmodule[DONE]
