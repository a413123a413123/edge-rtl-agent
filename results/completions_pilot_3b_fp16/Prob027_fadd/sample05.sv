module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Combinational logic

  logic sum1;
  logic cout1;

  // Implementing half adder for a and b
  assign sum1 = a ^ b;
  assign cout1 = a & b;

  // Implementing full adder with cin
  assign sum = sum1 ^ cin;
  assign cout = cout1 | cin;

endmodule
