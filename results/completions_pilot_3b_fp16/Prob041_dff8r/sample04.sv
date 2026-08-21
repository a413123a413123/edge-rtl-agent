module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // 8 D flip-flops
  reg [7:0] q_reg [0:7];

  always_ff @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      for (int i = 0; i < 8; i++)
        q_reg[i] <= 0;
    end
    else
    begin
      for (int i = 0; i < 8; i++)
        q_reg[i] <= d[i];
    end
  end

  assign q = q_reg;

endmodule
