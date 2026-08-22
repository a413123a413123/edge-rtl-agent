module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Sequential logic

  reg [7:0] counter;
  reg [7:0] result;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      counter <= 8'b0;
      result <= 8'b0;
      z <= 1'b0;
    end else begin
      counter <= counter + 1;
      result <= result + x;
      z <= result;
    end
  end

endmodule
