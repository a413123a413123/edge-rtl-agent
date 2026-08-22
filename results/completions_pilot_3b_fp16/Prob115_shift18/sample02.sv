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
        2'b00: begin
          shift_register <= { shift_register[63:1], shift_register[0] };
        end
        2'b01: begin
          shift_register <= { shift_register[63:8], shift_register[0:7] };
        end
        2'b10: begin
          shift_register <= { { shift_register[63:1], 1'b0 }, shift_register[63:1] };
        end
        2'b11: begin
          shift_register <= { { { shift_register[63:8], 1'b0 }, shift_register[63:8] }, shift_register[63:8] };
        end
      endcase
    end
  end

  assign q = shift_register;

endmodule
