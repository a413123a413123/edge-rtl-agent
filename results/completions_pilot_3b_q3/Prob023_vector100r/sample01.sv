
[BEGIN
TopModule(
  input logic [7:0] in_

  output logic [7:0] out;

  // Combinational logic

  assign out = input ^ (2 ^ 1) >> 7

endmodule[H]
