module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  // Sequential logic
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (int i = 0; i < 512; i++) begin
        q[i] <= q[i-1] ^ q[i+1];
      end
    end
  end

endmodule
