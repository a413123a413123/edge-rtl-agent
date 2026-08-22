
[BEGIN
TopModule(
  input_ logic [7:0] in_,
  output_and logic [7:0] out_and

  output_or logic [7:0] out_or

  output_xor_logic [7:0] out_xor

  and = input_[0] & input_[1] & input_[2] & input_[3];

endmodule[DONE]
