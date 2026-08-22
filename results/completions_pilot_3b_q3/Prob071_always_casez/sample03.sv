
TopModule(
  in_ in [3:0] out [3:0] pos [3:0]

  // Calculate the high bit of input

  if (in_ >= (1 << 7)) {
  // Calculate the result

  let result = in_ & (7 << 7);
endmodule

module


[END]
