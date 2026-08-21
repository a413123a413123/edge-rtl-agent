module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  // Sequential logic
  logic [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      next_q = {q[0], q[1:511]};
      for (int i = 1; i < 511; i++) begin
        next_q[i] = q[i-1] ^ q[i] ^ q[i+1];
      end
      next_q[511] = q[510]; // Boundary condition
      q <= next_q;
    end
  end

endmodule
