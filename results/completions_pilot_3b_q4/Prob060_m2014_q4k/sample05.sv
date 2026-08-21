module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Sequential logic

  reg [3:0] reg_data;

  always_ff @(posedge clk or posedge resetn) begin
    if (resetn) begin
      reg_data <= 4'b0;
    end else begin
      reg_data <= {in, reg_data[3:1]};
    end
  end

  assign out = reg_data[3];

endmodule
