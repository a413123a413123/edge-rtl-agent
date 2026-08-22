module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [31:0] in,
  output logic [31:0] out
);

  reg [31:0] prev_in;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      prev_in <= 32'b0;
      out <= 32'b0;
    end else begin
      out <= prev_in;
      if (in != prev_in) begin
        out <= in;
      end
    end
  end

endmodule
