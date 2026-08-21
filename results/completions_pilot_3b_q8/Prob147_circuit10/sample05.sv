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
  assign q = a | b;
  assign state = flip flop_out;

  // Sequential logic
  always @(posedge clk) begin
    if (a || b) begin
      flip flop_out <= 1'b1;
    end else begin
      flip flop_out <= 1'b0;
    end
  end

endmodule
