module TopModule
(
  input  logic p1a,
  input  logic p1b,
  input  logic p1c,
  input  logic p1d,
  input  logic p1e,
  input  logic p1f,
  input  logic p2a,
  input  logic p2b,
  input  logic p2c,
  input  logic p2d,
  output logic p1y,
  output logic p2y
);

  // Intermediate signals
  logic and1, and2, and3, and4, and5, and6, and7, and8;

  // AND gates
  assign and1 = p1a & p1b & p1c;
  assign and2 = p1d & p1e & p1f;
  assign and3 = p2a & p2b;
  assign and4 = p2c & p2d;

  // OR gates
  assign p1y = and1 | and2;
  assign p2y = and3 | and4;

endmodule
