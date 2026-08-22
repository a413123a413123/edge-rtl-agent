module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic [3:0] data,
  output logic [3:0] q
);

  // Sequential logic
  reg [3:0] shift_reg;

  // Shift operation
  always @(posedge clk) begin
    if (shift_ena) begin
      shift_reg <= {data, shift_reg[3:1]};
    end
  end

  // Count operation
  always @(posedge clk) begin
    if (count_ena) begin
      if (shift_reg != 4'h0) begin
        shift_reg <= shift_reg - 1;
      end
    end
  end

  // Output the result
  assign q = shift_reg;

endmodule
