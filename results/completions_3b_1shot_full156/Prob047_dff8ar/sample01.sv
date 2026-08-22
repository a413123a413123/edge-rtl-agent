module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // D flip-flops
  reg [7:0] q_reg [0:7];

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      q_reg <= 8'b0;
    end else begin
      q_reg <= d;
    end
  end

  assign q = q_reg;

endmodule
