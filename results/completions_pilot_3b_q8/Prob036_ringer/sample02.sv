module TopModule
(
  input  logic ring,
  input  logic vibrate_mode,
  output logic ringer,
  output logic motor
);

  always_comb
  begin
    ringer = 1'b0;
    motor = 1'b0;

    if (ring)
    begin
      if (vibrate_mode)
        motor = 1'b1;
      else
        ringer = 1'b1;
    end
  end

endmodule
