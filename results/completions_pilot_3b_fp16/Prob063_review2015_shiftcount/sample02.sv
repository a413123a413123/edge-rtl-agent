module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic [3:0] data,
  output logic [3:0] q
);

  logic [3:0] shift_register;

  // Sequential logic for shift register
  always_ff @(posedge clk) begin
    if (shift_ena) begin
      q <= data;
    end else begin
      q <= {q[2:0], q[3]};
    end
  end

  // Sequential logic for decrementing counter
  always_ff @(posedge clk) begin
    if (count_ena) begin
      q <= q - 1;
    end
  end

endmodule
