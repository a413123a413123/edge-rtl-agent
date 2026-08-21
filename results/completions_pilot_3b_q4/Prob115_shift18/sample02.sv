module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic ena,
  input  logic [1:0] amount,
  input  logic [63:0] data,
  output logic [63:0] q
);

  // Register declaration
  logic [63:0] shiftReg;

  // Sequential logic for shift register
  always @(posedge clk) begin
    if (load) begin
      shiftReg <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shiftReg <= {shiftReg[62:0], shiftReg[63]}; // Shift left by 1 bit
        2'b01: shiftReg <= {shiftReg[55:0], {64'h00000000, shiftReg[63:56]}}; // Shift left by 8 bits
        2'b10: shiftReg <= {shiftReg[63:1], '0}; // Arithmetic right shift by 1 bit
        2'b11: shiftReg <= {64'h00000000, shiftReg[63:7]}; // Arithmetic right shift by 8 bits
      endcase
    end
  end

  // Output assignment
  assign q = shiftReg;

endmodule
