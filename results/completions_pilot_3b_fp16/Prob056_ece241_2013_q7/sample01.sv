module TopModule
(
  input  logic clk,
  input  logic j,
  input  logic k,
  output logic Q
);

  logic Qold;

  always @(posedge clk) begin
    Qold <= Q;
    Q <= (j & ~Qold) | (~k & Qold);
  end

endmodule
