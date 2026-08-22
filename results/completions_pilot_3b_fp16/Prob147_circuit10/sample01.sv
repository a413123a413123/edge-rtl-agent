module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  // Combinational logic
  assign q = a ^ b;

  // Sequential logic
  logic ff;

  always @(posedge clk) begin
    ff <= q;
  end

  assign state = ff;

endmodule
