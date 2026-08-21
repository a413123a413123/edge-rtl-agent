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
    if (j) begin
      Q = ~Qold;
    end else begin
      Q = k ? 0 : Qold;
    end
  end

endmodule
