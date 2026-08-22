module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic [1:0] byteena,
  input  logic [15:0] d,
  output logic [15:0] q
);

  // D flip-flops
  reg [15:0] q_reg [0:15];

  // Reset logic
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      q_reg <= 16'b0;
    end
  end

  // Write logic
  always_ff @(posedge clk) begin
    if (byteena[1]) begin
      q_reg[15:8] <= d[15:8];
    end
    if (byteena[0]) begin
      q_reg[7:0] <= d[7:0];
    end
  end

  // Output
  assign q = q_reg;

endmodule
