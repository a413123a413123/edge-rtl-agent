module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] d,
  output logic [7:0] q
);

  // D flip-flops with active high synchronous reset

  reg [7:0] q_reg [0:7];

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (int i = 0; i < 8; i = i + 1) begin
        q_reg[i] <= 8'b00000000;
      end
    end else begin
      for (int i = 0; i < 8; i = i + 1) begin
        q_reg[i] <= d[i];
      end
    end
  end

  assign q = q_reg;

endmodule
