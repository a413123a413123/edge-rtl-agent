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

  // Shift logic
  always @(posedge clk) begin
    if (load) begin
      shift_reg <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shift_reg <= {shift_reg[63:1], shift_reg[0]};
        2'b01: shift_reg <= {shift_reg[63:7], shift_reg[6:0]};
        2'b10: shift_reg <= {shift_reg[63:1], {63{shift_reg[0]}}};
        2'b11: shift_reg <= {shift_reg[63:8], {63{shift_reg[7]}}, shift_reg[6:0]};
      endcase
    end
  end

  // Output the shift register contents
  assign q = shift_reg;

endmodule
