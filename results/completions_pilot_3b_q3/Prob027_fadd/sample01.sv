
module

module TopModule {
  in_: in_
  out_b: out_b
  out_c: out_c
  in_c: in_c
  out_s: out_s

  in_c = in_c + 1;
  out_s = out_s + 1;
  sum = in_c + in_s;
  out_b = out_b + 1;
  out_c = out_c + 1;
  cout = out_c + 1;
  carry_in = in_c;
  carry_out = out_c;
}
endmodule[DONE]
