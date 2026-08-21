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

  always @(posedge clk) begin
    if (load) begin
      shift_register <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shift_register <= {shift_register[62:0], shift_register[63]};
        2'b01: shift_register <= {shift_register[55:0], shift_register[63:56]};
        2'b10: begin
          shift_register <= {shift_register[63], shift_register[62:0]};
          for (int i = 0; i < 7; i++) begin
            shift_register[63-i] <= shift_register[64-i];
          end
        end
        2'b11: begin
          shift_register <= {shift_register[63], shift_register[62:0]};
          for (int i = 0; i < 7; i++) begin
            shift_register[63-i] <= shift_register[64-i];
          end
        end
      endcase
    end
  end

  assign q = shift_register;

endmodule
