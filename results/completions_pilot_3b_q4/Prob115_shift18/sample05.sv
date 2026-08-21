module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic ena,
  input  logic [1:0] amount,
  input  logic [63:0] data,
  output logic [63:0] q
);

  // Register to hold the current state of the shift register
  logic [63:0] reg;

  // Asynchronous load operation
  always_ff @(posedge clk) begin
    if (load) reg <= data;
  end

  // Synchronous shift operation
  always_ff @(posedge clk) begin
    if (ena) begin
      case (amount)
        2'b00: reg <= {reg[63:1], reg[0]}; // Shift left by 1 bit
        2'b01: reg <= {reg[63:8], reg[7:0]}; // Shift left by 8 bits
        2'b10: reg <= {reg[63:1:amount], reg[amount+63:1]}; // Arithmetic right shift by 1 bit
        2'b11: reg <= {reg[63:8:amount], reg[amount+8:1]}; // Arithmetic right shift by 8 bits
        default: reg <= reg; // Default case to prevent synthesis errors
      endcase
    end
  end

  // Assign output to the register
  assign q = reg;

endmodule
