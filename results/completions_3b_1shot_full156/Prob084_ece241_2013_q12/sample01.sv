module TopModule
(
  input  logic clk,
  input  logic enable,
  input  logic S,
  input  logic A,
  input  logic B,
  input  logic C,
  output logic Z
);

  // Shift register with 8 D-type flip-flops
  reg [7:0] shift_register;

  // Multiplexer to select output based on ABC
  always @(posedge clk) begin
    if (enable) begin
      shift_register <= {S, shift_register[7:1]};
    end
  end

  // Multiplexer to select Z based on ABC
  always @(posedge clk) begin
    case ({A, B, C})
      3'b000: Z = shift_register[0];
      3'b001: Z = shift_register[1];
      3'b010: Z = shift_register[2];
      3'b011: Z = shift_register[3];
      3'b100: Z = shift_register[4];
      3'b101: Z = shift_register[5];
      3'b110: Z = shift_register[6];
      3'b111: Z = shift_register[7];
      default: Z = 1'b0; // Default case, should not happen
    endcase
  end

endmodule
