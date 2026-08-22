module TopModule
(
  input  logic clock,
  input  logic a,
  output logic p,
  output logic q
);

  always @(posedge clock) begin
    if (a) begin
      p = 1'b1;
      q = 1'b0;
    end else begin
      p = 1'b0;
      q = 1'b1;
    end
  end

endmodule
