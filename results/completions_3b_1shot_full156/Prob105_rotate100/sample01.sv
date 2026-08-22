module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [1:0] ena,
  input  logic [99:0] data,
  output logic [99:0] q
);

  // Register to hold the 100-bit data
  logic [99:0] reg;

  // Synchronous load
  always_ff @(posedge clk) begin
    if (load) begin
      reg <= data;
    end
  end

  // Synchronous rotation
  always_ff @(posedge clk) begin
    if (ena[1] && ena[0]) begin
      // Rotate left by one bit
      reg <= {reg[99:1], reg[0]};
    end else if (ena[1] && !ena[0]) begin
      // Rotate right by one bit
      reg <= {reg[98:0], reg[99]};
    end
  end

  // Output the register contents
  assign q = reg;

endmodule
