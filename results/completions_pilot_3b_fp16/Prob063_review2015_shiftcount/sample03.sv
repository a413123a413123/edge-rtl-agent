module TopModule
(
  input  logic clk,
  input  logic shift_ena,
  input  logic count_ena,
  input  logic data,
  output logic [3:0] q
);

  // Sequential logic

  logic [3:0] reg;

  always_ff @(posedge clk) begin
    if (shift_ena) begin
      reg[3] <= data;
      reg[2:0] <= reg[3:1];
    end else if (count_ena) begin
      if (reg[3] == 0) begin
        reg <= {4'b0000}; // Clear the register if the count reaches 0
      end else begin
        reg <= reg - 1;
      end
    end
  end

  assign q = reg;

endmodule
