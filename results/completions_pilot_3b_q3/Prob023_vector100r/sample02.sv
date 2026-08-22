
TopModule(
  in_ logic [1:0] in_,
  out logic [1:0] out);

  // Reverse the input and write the result to the output
0
  assign out = in_.reverse();

endmodule
