module TopModule (
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic out_assign,
  output logic out_always_comb,
  output logic out_always_ff
);

  // Assign statement
  assign out_assign = a ^ b;

  // Combinational always block
  always_comb begin
    out_always_comb = a ^ b;
  end

  // Clocked always block with flip-flop
  always_ff @(posedge clk) begin
    out_always_ff = a ^ b;
  end

endmodule
