module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Internal signals
  logic carry;

  // Sum calculation
  assign sum = a ^ b ^ cin;

  // Carry calculation
  assign carry = (a & b) | (a & cin) | (b & cin);

  // Outputting carry-out
  assign cout = carry;

endmodule
