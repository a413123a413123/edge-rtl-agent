module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  // Flip-flop logic

  always_ff @(posedge clk) begin
    if (j) begin
      Q <= ~Q;
    end else if (k) begin
      Q <= 1'b0;
    end else begin
      Q <= Q;
    end
  end

endmodule
