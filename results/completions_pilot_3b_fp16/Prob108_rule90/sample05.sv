module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  logic [512:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (int i = 0; i < 512; i++) begin
        next_q[i] = q[i-1] ^ q[i+1];
      end
      q <= next_q;
    end
  end

endmodule
