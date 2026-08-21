module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  // Flip-flop logic

  logic Qold;

  always @(posedge clk) begin
    if (j == 1'b1) begin
      Q = 1'b1;
    end else if (k == 1'b1) begin
      Q = 1'b0;
    end else begin
      Q = Qold;
    end
  end

endmodule
