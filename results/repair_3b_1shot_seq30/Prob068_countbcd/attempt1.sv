module TopModule
(
  input  logic clk,
  input  logic reset,
  output logic [2:0] ena,
  output logic [15:0] q
);

  // Sequential logic

  reg [3:0] ones;
  reg [3:0] tens;
  reg [3:0] hundreds;
  reg [3:0] thousands;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      ones <= 4'b0;
      tens <= 4'b0;
      hundreds <= 4'b0;
      thousands <= 4'b0;
    end else begin
      ones <= ones + 1;
      if (ones == 10) begin
        ones <= 4'b0;
        tens <= tens + 1;
      end
      if (tens == 10) begin
        tens <= 4'b0;
        hundreds <= hundreds + 1;
      end
      if (hundreds == 10) begin
        hundreds <= 4'b0;
        thousands <= thousands + 1;
      end
    end
  end

  assign q = {thousands, hundreds, tens, ones};
  assign ena = {ones, tens, hundreds};

endmodule
