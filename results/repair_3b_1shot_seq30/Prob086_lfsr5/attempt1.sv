module TopModule
(
  input  logic clk,
  input  logic reset,
  output logic [4:0] q
);

  // Sequential logic

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 5'b11111;
    end else begin
      q <= {q[4:1], q[0] ^ q[3]};
    end
  end

endmodule
