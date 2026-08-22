
module TopModule(
  in_ [4:0] out_

  out_and [4:0] or

  out_xor [4:0] xor

  // Combinational logic

  assign out_and = in_[2:0] | in_b[2:0];
  assign out_or = in_[3:0] | in_b[3:0];
  assign out_xor = in_[4:0] | in_b[4:0];

endmodule
