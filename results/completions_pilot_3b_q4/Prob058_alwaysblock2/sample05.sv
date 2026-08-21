module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic out_assign,
  output logic out_always_comb,
  output logic out_always_ff
);

  // Combinational always block
  assign out_always_comb = a ^ b;

  // Assign statement
  assign out_assign = a ^ b;

  // Clocked always block
  reg [0:0] reg_out;
  always_ff @(posedge clk) begin
    reg_out <= a ^ b;
    out_always_ff <= reg_out;
  end

endmodule
