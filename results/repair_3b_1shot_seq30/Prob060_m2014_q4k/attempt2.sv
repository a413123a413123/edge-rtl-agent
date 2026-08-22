module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Sequential logic

  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      out <= 1'b0;
    end else begin
      out <= in;
    end
  end

endmodule
