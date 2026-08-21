module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Combinational logic

  logic carry = a & b | a & cin | b & cin;

  assign cout = carry;
  assign sum = a ^ b ^ cin;

endmodule
