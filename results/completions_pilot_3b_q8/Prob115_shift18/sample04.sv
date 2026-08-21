module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic ena,
  input  logic [1:0] amount,
  input  logic [63:0] data,
  output logic [63:0] q
);

  logic [63:0] shift_reg;

  always @(posedge clk) begin
    if (load) begin
      shift_reg <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shift_reg <= {shift_reg[63:1], 1'b0};
        2'b01: shift_reg <= {shift_reg[63:8], {8{shift_reg[7]}}};
        2'b10: shift_reg <= {shift_reg[63:7], shift_reg[63:7]};
        2'b11: shift_reg <= {8{shift_reg[63]}}, shift_reg[63:8];
      endcase
    end
  end

  assign q = shift_reg;

endmodule
