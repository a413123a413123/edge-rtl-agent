module TopModule
(
  input  logic mode,
  input  logic too_cold,
  input  logic too_hot,
  input  logic fan_on,
  output logic heater,
  output logic aircon,
  output logic fan
);

  // Combinational logic

  always_comb begin
    heater = (mode == 1) && too_cold;
    aircon = (mode == 0) && too_hot;
    fan = fan_on || heater || aircon;
  end

endmodule
