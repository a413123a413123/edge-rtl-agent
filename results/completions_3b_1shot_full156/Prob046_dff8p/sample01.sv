module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // Instantiate 8 D flip-flops
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 8'b110100; // Reset to 0x34
    end else begin
      q <= d;
    end
  end

endmodule
