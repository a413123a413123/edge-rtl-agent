module TopModule
(
  input  logic [0:0] mode,
  input  logic [0:0] too_cold,
  input  logic [0:0] too_hot,
  input  logic [0:0] fan_on,
  output logic heater,
  output logic aircon,
  output logic fan
);

  // Combinational logic
  assign heater = (mode == 1) && too_cold;
  assign aircon = (mode == 0) && too_hot;
  assign fan = (fan_on || heater || aircon);

endmodule
