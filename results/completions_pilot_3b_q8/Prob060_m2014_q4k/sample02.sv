module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Instantiate four D flip-flops
  reg [3:0] shift_register;

  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      shift_register <= 4'b0;
    end else begin
      shift_register <= {in, shift_register[3:1]};
    end
  end

  // Assign the output to the last flip-flop
  assign out = shift_register[3];

endmodule
