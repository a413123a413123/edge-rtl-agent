module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // D Flip-Flops

  reg [7:0] q_reg;

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      q_reg <= 8'b0;
    end
    else
    begin
      q_reg <= d;
    end
  end

  assign q = q_reg;

endmodule
