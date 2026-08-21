module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // 8 D flip-flops
  reg [7:0] q0, q1, q2, q3, q4, q5, q6, q7;

  always @(posedge clk or posedge reset)
  begin
    if (reset) begin
      q0 <= 8'h00;
      q1 <= 8'h00;
      q2 <= 8'h00;
      q3 <= 8'h00;
      q4 <= 8'h00;
      q5 <= 8'h00;
      q6 <= 8'h00;
      q7 <= 8'h00;
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
  end

  assign q = q7;

endmodule
