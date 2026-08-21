module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Sequential logic

  always_ff @(posedge clk or negedge resetn)
  begin
    if (!resetn)
      out <= 1'b0;
    else
      out <= in;
  end

endmodule
