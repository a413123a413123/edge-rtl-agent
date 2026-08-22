module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  logic Qold;

  // Sequential logic

  always @(posedge clk) begin
    Qold = Q;
    if (j) Q = 1'b1;
    else if (k) Q = 1'b0;
    else Q = ~Qold;
  end

endmodule
