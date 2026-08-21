module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Combinational logic

  logic carry2;
  logic carry1;

  add2bit #(.N(2)) add2bit_inst (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .carry(carry2)
  );

  add2bit #(.N(2)) add2bit_inst2 (
    .a(carry1),
    .b(carry2),
    .cin(1'b0),
    .sum(cout),
    .carry(carry1)
  );

  assign carry1 = a & b;

endmodule

module add2bit
(
  input  logic [1:0] a,
  input  logic [1:0] b,
  input  logic cin,
  output logic sum,
  output logic carry
);

  logic [2:0] sum2;

  add3bit #(.N(3)) add3bit_inst (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum2),
    .carry(carry)
  );

  assign sum = sum2[2];

endmodule

module add3bit
(
  input  logic [2:0] a,
  input  logic [2:0] b,
  input  logic cin,
  output logic sum,
  output logic carry
);

  assign sum = a + b + cin;
  assign carry = (a & b) | (a & cin) | (b & cin);

endmodule

