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

  assign heater = (mode && too_cold) || fan_on;
  assign aircon = (!mode && too_hot) || fan_on;
  assign fan = fan_on || heater || aircon;

endmodule
