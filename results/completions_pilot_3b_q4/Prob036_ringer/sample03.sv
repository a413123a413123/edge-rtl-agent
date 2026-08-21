module TopModule
(
  input  logic ring,
  input  logic vibrate_mode,
  output logic ringer,
  output logic motor
);

  always_comb begin
    if (vibrate_mode)
      motor = 1'b1;
    else
      ringer = 1'b1;
  end

endmodule
