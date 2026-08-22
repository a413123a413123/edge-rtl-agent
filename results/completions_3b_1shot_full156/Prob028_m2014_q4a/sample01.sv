module TopModule
(
  input  logic d,
  input  logic ena,
  output logic q
);

  always @(posedge ena) begin
    q <= d;
  end

endmodule
