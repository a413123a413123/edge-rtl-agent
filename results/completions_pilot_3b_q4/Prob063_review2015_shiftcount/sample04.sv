module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic [3:0] data,
  output logic [3:0] q
);

  // Sequential logic for shift register and counter

  always @(posedge clk) begin
    if (shift_ena) begin
      q = {data, q[3:1]};
    end else if (count_ena) begin
      if (q != 4'b0000) begin
        q = q - 1'b1;
      end
    end else begin
      // Do nothing
    end
  end

endmodule
