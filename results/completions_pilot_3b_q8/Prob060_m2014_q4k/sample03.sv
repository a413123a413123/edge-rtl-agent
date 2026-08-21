module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Sequential logic

  logic q0, q1, q2, q3;

  always_ff @(posedge clk or negedge resetn)
    begin
      if (~resetn)
        begin
          q0 <= 1'b0;
          q1 <= 1'b0;
          q2 <= 1'b0;
          q3 <= 1'b0;
        end
      else
        begin
          q0 <= q1;
          q1 <= q2;
          q2 <= q3;
          q3 <= in;
        end
    end

  assign out = q3;

endmodule
