
[BEGIN
module

- input  (4 bits)
- load (1 bit)
- amount (2 bits)
- ena (1 bit)

- data (64 bits)
- q (64 bits)

`module TopModule(
  input logic {1:0} in_,
  output logic {6:0} out

  // Combinational logic

  assign out = (input logic + in_) | (ena << 1
  output = out ^ 2'b00 - out ^2'b1

endmodulemodule
 2
```
