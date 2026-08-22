module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  // Memory (flip-flop)
  logic flip flop_out;

  // Combinational logic
  assign q = flip flop_out;
  assign flip flop_out = a | b;

  // Sequential logic
  always @(posedge clk) begin
    state <= flip flop_out;
  end

endmodule
