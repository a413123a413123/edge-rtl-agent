module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic data,
  output logic [3:0] q
);

  always @(posedge clk) begin
    if (shift_ena) begin
      q = {q[3:1], data};
    end else if (count_ena) begin
      if (q > 0) begin
        q = q - 1;
      end
    end
  end

endmodule
