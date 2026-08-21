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
      motor = 1;
      ringer = 0;
    end else begin
      motor = 0;
      ringer = ring;
    end
  end

endmodule
