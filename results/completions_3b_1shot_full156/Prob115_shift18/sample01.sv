module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic ena,
  input  logic [1:0] amount,
  input  logic [63:0] data,
  output logic [63:0] q
);

  // Register to hold the shift register contents
  logic [63:0] shift_reg;

  // Shift logic
  always_ff @(posedge clk) begin
    if (load) begin
      shift_reg <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shift_reg <= {shift_reg[62:0], shift_reg[63]};
        2'b01: shift_reg <= {shift_reg[55:0], shift_reg[63:56]};
        2'b10: shift_reg <= {shift_reg[63:1], {1'b0, shift_reg[62:1]}};
        2'b11: shift_reg <= {shift_reg[55:0], {1'b0, shift_reg[63:56]}};
      endcase
    end
  end

  // Assign output
  assign q = shift_reg;

endmodule
