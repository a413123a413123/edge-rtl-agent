module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Sum calculation
  assign sum = a ^ b ^ cin;

  // Carry-out calculation
  assign cout = (a & b) | (b & cin) | (a & cin);

endmodule
