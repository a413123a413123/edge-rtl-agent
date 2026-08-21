module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // D flip-flops
  reg [7:0] q0, q1, q2, q3, q4, q5, q6, q7;

  // Synchronous reset
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q0 <= 8'b0;
    else
      q0 <= d;
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q1 <= 8'b0;
    else
      q1 <= q0;
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q2 <= 8'b0;
    else
      q2 <= q1;
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q3 <= 8'b0;
    else
      q3 <= q2;
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q4 <= 8'b0;
    else
      q4 <= q3;
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q5 <= 8'b0;
    else
      q5 <= q4;
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q6 <= 8'b0;
    else
      q6 <= q5;
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q7 <= 8'b0;
    else
      q7 <= q6;
  end

  // Output
  assign q = {q7, q6, q5, q4, q3, q2, q1, q0};

endmodule
