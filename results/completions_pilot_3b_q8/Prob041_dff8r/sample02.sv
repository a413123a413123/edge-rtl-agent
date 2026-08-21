module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // D flip-flops

  reg [7:0] q_reg [0:7];

  always_ff @(posedge clk or posedge reset)
  begin
    if (reset)
      q_reg <= 8'b0;
    else
      q_reg <= d;
  end

  assign q = q_reg;

endmodule
