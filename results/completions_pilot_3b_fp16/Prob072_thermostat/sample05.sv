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
    heater = mode && too_cold;
    aircon = mode && too_hot;
    fan = fan_on || (mode && (too_cold || too_hot));
  end

endmodule
