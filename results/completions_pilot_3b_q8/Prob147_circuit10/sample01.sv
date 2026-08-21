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
  logic ff_state;
  always @(posedge clk)
  begin
    ff_state <= q;
  end

  // Assign state output
  assign state = ff_state;

endmodule
