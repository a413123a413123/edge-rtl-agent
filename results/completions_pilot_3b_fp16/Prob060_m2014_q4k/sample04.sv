module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Sequential logic

  reg [3:0] reg_out;

  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      reg_out <= 4'b0000;
    end else begin
      reg_out <= {reg_out[2:0], in};
    end
  end

  assign out = reg_out[3];

endmodule
