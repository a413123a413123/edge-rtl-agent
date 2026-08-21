module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  // Memory for the system
  reg [511:0] q_reg;

  // Rule 90 logic
  always @(posedge clk) begin
    if (load) begin
      q_reg = data;
    end else begin
      for (int i = 0; i < 512; i = i + 2) begin
        q_reg[i] = q_reg[i - 1] ^ q_reg[i + 1];
      end
      q_reg[0] = 0; // Boundary condition
      q_reg[511] = 0; // Boundary condition
    end
  end

  // Output the result
  assign q = q_reg;

endmodule
