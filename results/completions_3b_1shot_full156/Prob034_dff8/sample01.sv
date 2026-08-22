module TopModule
(
  input  logic clk,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // D flip-flops
  reg [7:0] q0, q1, q2, q3, q4, q5, q6, q7;

  // Sequential logic
  always @(posedge clk) begin
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
