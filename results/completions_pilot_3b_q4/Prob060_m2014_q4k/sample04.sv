module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Sequential logic

  reg [3:0] reg_out;

  always_ff @(posedge clk or posedge resetn)
  begin
    if (resetn == 1'b0)
      reg_out <= 4'b0000;
    else
      reg_out <= {in, reg_out[3:1]};
  end

  assign out = reg_out[3];

endmodule
