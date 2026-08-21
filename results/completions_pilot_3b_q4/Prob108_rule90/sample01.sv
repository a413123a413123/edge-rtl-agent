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
      q <= {q[510:0], q[511] ^ q[0] ^ q[1]};
    end
  end

endmodule
