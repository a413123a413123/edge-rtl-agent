module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Combinational logic
  logic carry;

  // Half adder
  logic half_sum;
  logic half_carry;
  half_adder ha (half_sum, half_carry, a, b);

  // Full adder
  full_adder fa (sum, cout, half_carry, cin);

endmodule

module half_adder
(
  output logic sum,
  output logic carry,
  input  logic a,
  input  logic b
);

  assign sum = a ^ b;
  assign carry = a & b;

endmodule

module full_adder
(
  output logic sum,
  output logic cout,
  input  logic a,
  input  logic b,
  input  logic cin
);

  logic carry1;
  logic carry2;

  // First half adder
  half_adder ha1 (sum, carry1, a, b);

  // Second half adder with carry-in
  half_adder ha2 (sum, carry2, carry1, cin);

  // Sum is the XOR of the two half adder sums
  // Carry-out is the OR of the two half adder carries
  assign cout = carry1 | carry2;

endmodule

[BEGIN]
