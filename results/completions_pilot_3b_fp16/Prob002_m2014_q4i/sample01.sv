module TopModule
(
  output logic out
);

  always_ff @(posedge clk) begin
    out <= 1'b0;
  end

endmodule
