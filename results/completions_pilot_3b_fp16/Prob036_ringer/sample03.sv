module TopModule
(
  input  logic ring,
  input  logic vibrate_mode,
  output logic ringer,
  output logic motor
);

  // Combinational logic

  always_comb
  begin
    ringer = ring & ~vibrate_mode;
    motor = vibrate_mode;
  end

endmodule
