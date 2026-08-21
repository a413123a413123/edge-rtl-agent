module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  logic [511:0] q_prev;

  // Sequential logic (FFs)
  always_ff @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (int i = 1; i < 511; i = i + 1) begin
        q[i] <= q[i-1] ^ q[i+1];
      end
      q[0] <= q_prev[0]; // Boundary condition: left cell is zero
      q[511] <= q_prev[511]; // Boundary condition: right cell is zero
    end
  end

  // Combinational logic to handle load transition
  always_comb begin
    q_prev = q;
  end

endmodule
