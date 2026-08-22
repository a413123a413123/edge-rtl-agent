

[BEGIN
TopModule(input_, input_load, input_data) load,
0
  output_q(load, load, state)

  q_next = out_q | input_load | input_data | (input_ + 1)
endmodule
```
