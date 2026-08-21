module TopModule
(
  input  logic ring,
  input  logic vibrate_mode,
  output logic ringer,
  output logic motor
);

  // Combinational logic

  always_comb begin
    if (vibrate_mode) begin
      motor = 1'b1;
      ringer = 1'b0;
    end else if (ring) begin
      ringer = 1'b1;
      motor = 1'b0;
    end else begin
      ringer = 1'b0;
      motor = 1'b0;
    end
  end

endmodule
