module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic in,
  output logic out
);

  // D flip-flops

  logic dff_0, dff_1, dff_2, dff_3;

  // Sequential logic

  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      dff_0 <= 1'b0;
      dff_1 <= 1'b0;
      dff_2 <= 1'b0;
      dff_3 <= 1'b0;
    end else begin
      dff_0 <= in;
      dff_1 <= dff_0;
      dff_2 <= dff_1;
      dff_3 <= dff_2;
    end
  end

  // Output

  assign out = dff_3;

endmodule
