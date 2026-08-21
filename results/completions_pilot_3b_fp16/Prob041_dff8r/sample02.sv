module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // 8 D flip-flops
  reg [7:0] q0, q1, q2, q3, q4, q5, q6, q7;

  // Synchronous reset
  always_ff @(posedge clk or posedge reset)
    if (reset) begin
      q0 <= 8'b0;
      q1 <= 8'b0;
      q2 <= 8'b0;
      q3 <= 8'b0;
      q4 <= 8'b0;
      q5 <= 8'b0;
      q6 <= 8'b0;
      q7 <= 8'b0;
    end else begin
      q0 <= d;
      q1 <= q0;
      q2 <= q1;
      q3 <= q2;
      q4 <= q3;
      q5 <= q4;
      q6 <= q5;
      q7 <= q6;
    end

  assign q = q7;

endmodule
