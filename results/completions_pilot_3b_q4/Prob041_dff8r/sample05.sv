module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // Instantiate 8 D Flip-Flops with active high synchronous reset

  dffs: for (genvar i = 0; i < 8; i++) begin
    dff u_dff (
      .d(d[i]),
      .clk(clk),
      .reset(reset),
      .q(q[i])
    );
  end

endmodule
