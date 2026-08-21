module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic ena,
  input  logic [1:0] amount,
  input  logic [63:0] data,
  output logic [63:0] q
);

  logic [63:0] shift_register;

  always @(posedge clk or posedge load)
  begin
    if (load)
    begin
      shift_register <= data;
    end
    else if (ena)
    begin
      case (amount)
        2'b00: shift_register <= {shift_register[62:0], 1'b0};
        2'b01: shift_register <= {shift_register[55:0], shift_register[63:56], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        2'b10: shift_register <= {1'b0, shift_register[63:1]};
        2'b11: shift_register <= {shift_register[63:8], shift_register[7:1]};
      endcase
    end
  end

  assign q = shift_register;

endmodule
