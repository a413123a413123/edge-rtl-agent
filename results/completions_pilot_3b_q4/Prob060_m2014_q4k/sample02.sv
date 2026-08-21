module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Instantiate four D flip-flops
 dff dff_0 (
    .clk(clk),
    .resetn(resetn),
    .in(in),
    .out(out)
  );

endmodule
