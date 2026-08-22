module TopModule
(
  input  logic clk,
  input  logic in,
  output logic out
);

  // D flip-flop
  logic d;
  dff dff_inst (
    .clk(clk),
    .d(d),
    .q(out)
  );

  // XOR gate
  xor xor_inst (
    .a(out),
    .b(in),
    .y(d)
  );

endmodule
