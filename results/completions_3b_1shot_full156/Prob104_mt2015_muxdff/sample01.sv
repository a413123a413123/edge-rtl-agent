module TopModule (
  input  logic [2:0] r,
  input  logic L,
  input  logic clk,
  output reg [2:0] q
);

  // Instantiate three TopModule instances
  TopModule ff1 (.r(r[0]), .L(L), .clk(clk), .q(q[0]));
  TopModule ff2 (.r(r[1]), .L(L), .clk(clk), .q(q[1]));
  TopModule ff3 (.r(r[2]), .L(L), .clk(clk), .q(q[2]));

endmodule

module TopModule (
  input  logic [2:0] r,
  input  logic L,
  input  logic clk,
  output reg [2:0] q
);

  // Flip-flop logic
  always @(posedge clk) begin
    if (L) begin
      q <= r;
    end else begin
      q <= {q[1] ^ q[2], q[0], q[2]};
    end
  end

endmodule
