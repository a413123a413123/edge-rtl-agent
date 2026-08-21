module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // 8 D flip-flops with active high synchronous reset
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 8'b0;
    end else begin
      q <= d;
    end
  end

endmodule
