module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic ena,
  input  logic [1:0] amount,
  input  logic [63:0] data,
  output logic [63:0] q
);

  // Internal signals
  logic [63:0] shift_reg;

  // Load data into the shift register when load is high
  always @(posedge clk) begin
    if (load)
      shift_reg <= data;
  end

  // Shift the register based on amount and enable signals
  always @(posedge clk) begin
    if (ena) begin
      case (amount)
        2'b00: shift_reg <= {shift_reg[63:1], 1'b0};
        2'b01: shift_reg <= {shift_reg[63:8], 7'b0000000};
        2'b10: shift_reg <= {1'b0, shift_reg[63:1]};
        2'b11: shift_reg <= {shift_reg[63:8], 7'b0000000};
      endcase
    end
  end

  // Assign the shift register to the output q
  assign q = shift_reg;

endmodule
