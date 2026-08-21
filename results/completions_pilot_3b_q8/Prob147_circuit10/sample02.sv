module TopModule
(
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  // flip-flop declaration
  reg [0:0] q_reg;

  // Sequential logic
  always @(posedge clk) begin
    if (a) begin
      if (b) begin
        q_reg <= 1'b1;
      end else begin
        q_reg <= 1'b0;
      end
    end else begin
      q_reg <= 1'b0;
    end
  end

  // Combinational logic to determine state
  assign state = q_reg;

endmodule
