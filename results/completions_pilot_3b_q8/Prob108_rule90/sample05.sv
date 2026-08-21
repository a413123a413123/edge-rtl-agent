module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  // Memory for the array of cells
  reg [511:0] q_reg;

  // Next state computation
  always @(posedge clk) begin
    if (load) begin
      q_reg <= data;
    end else begin
      for (int i = 1; i < 511; i = i + 1) begin
        q_reg[i] <= q_reg[i - 1] ^ q_reg[i + 1];
      end
      q_reg[0] <= q_reg[511]; // Wrap around the boundary
      q_reg[511] <= q_reg[0]; // Wrap around the boundary
    end
  end

  // Output the current state of the cells
  assign q = q_reg;

endmodule
