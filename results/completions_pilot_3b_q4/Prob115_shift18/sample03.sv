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
  reg [63:0] shiftRegister;

  // Process for shift operation
  always @(posedge clk) begin
    if (load) begin
      shiftRegister <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shiftRegister <= {data[62:0], data[63]};
        2'b01: shiftRegister <= data[55:0] << 8;
        2'b10: shiftRegister <= {shiftRegister[63], shiftRegister[62:0]};
        2'b11: shiftRegister <= {shiftRegister[63:8], shiftRegister[7:0]};
        default: begin // Invalid case, do nothing
        end
      endcase
    end
  end

  // Output assignment
  assign q = shiftRegister;

endmodule
