module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // Synchronous reset
  reg [3:0] data;

  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      data <= 4'b0000;
    end else begin
      data <= {in, data[3:1]};
    end
  end

  assign out = data[3];

endmodule
