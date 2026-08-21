module TopModule
(
  input  wire clk,
  input  wire a,
  input  wire b,
  output reg out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // Assign statement
  assign out_assign = a ^ b;

  // Combinational always block
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // Clocked always block
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule
