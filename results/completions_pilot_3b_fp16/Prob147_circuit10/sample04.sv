module TopModule (
  input  logic clk,
  input  logic a,
  input  logic b,
  output logic q,
  output logic state
);

  logic [0:0] mem;

  always @(posedge clk) begin
    state <= mem;
    mem <= b;
    q <= mem;
  end

endmodule
