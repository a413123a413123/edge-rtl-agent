module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic data,
  output logic [3:0] q
);

  logic [3:0] reg_q;

  always @(posedge clk) begin
    if (shift_ena) begin
      q = {q[2:0], data};
    end else if (count_ena) begin
      q = q - 1;
    end else begin
      // Do nothing if both are 0
    end
  end

endmodule
