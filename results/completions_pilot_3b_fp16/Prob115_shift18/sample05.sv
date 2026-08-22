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

  always_ff @(posedge clk) begin
    if (load) begin
      shift_register <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shift_register <= {data[62:0], data[63]};
        2'b01: shift_register <= {data[55:0], data[63:56]};
        2'b10: shift_register <= data[63:1] << 1;
        2'b11: shift_register <= data[63:1] >> 8;
      endcase
    end
  end

  assign q = shift_register;

endmodule
