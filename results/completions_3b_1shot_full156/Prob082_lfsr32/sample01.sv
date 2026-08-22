module TopModule
(
  input  logic clk,
  input  logic reset,
  output logic [31:0] q
);

  // Sequential logic

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      q <= {q[31:2], q[21:2], q[19:2], q[17:2], q[15:2], q[13:2], q[11:2], q[9:2], q[7:2], q[5:2], q[3:2], q[1:2], q[0]};
    end
  end

endmodule
