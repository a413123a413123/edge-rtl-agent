module TopModule
(
  input  logic ring,
  input  logic vibrate_mode,
  output logic ringer,
  output logic motor
);

  always_comb
  begin
    ringer = ring;
    motor = vibrate_mode;

    if (ring && vibrate_mode)
      motor = 1'b0;
  end

endmodule
