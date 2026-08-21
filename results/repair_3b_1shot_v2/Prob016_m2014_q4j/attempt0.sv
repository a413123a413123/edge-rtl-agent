module TopModule
(
  input  logic [3:0] x,
  input  logic [3:0] y,
  output logic [4:0] sum
);

  // Full adders
  wire [1:0] carry1, carry2, carry3;
  wire [3:0] sum1, sum2;

  // First full adder
  full_adder fa1 (
    .a(x[0]),
    .b(y[0]),
    .cin(1'b0),
    .sum(sum1[0]),
    .cout(carry1)
  );

  // Second full adder
  full_adder fa2 (
    .a(x[1]),
    .b(y[1]),
    .cin(carry1),
    .sum(sum1[1]),
    .cout(carry2)
  );

  // Third full adder
  full_adder fa3 (
    .a(x[2]),
    .b(y[2]),
    .cin(carry2),
    .sum(sum1[2]),
    .cout(carry3)
  );

  // Fourth full adder
  full_adder fa4 (
    .a(x[3]),
    .b(y[3]),
    .cin(carry3),
    .sum(sum1[3]),
    .cout(sum[4])
  );

  // Combine the results
  assign sum[0] = sum1[0];
  assign sum[1] = sum1[1];
  assign sum[2] = sum1[2];
  assign sum[3] = sum1[3];
  assign sum[4] = sum[4];

endmodule

module full_adder
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic sum,
  output logic cout
);

  // Sum and carry logic
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
