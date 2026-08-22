module TopModule
(
  input  logic a,
  input  logic b,
  output logic out_assign,
  output logic out_alwaysblock
);

  // Assign statement
  assign out_assign = a & b;

  // Combinational always block
  always_comb begin
    out_alwaysblock = a & b;
  end

endmodule
