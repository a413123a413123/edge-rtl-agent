
module TopModule(
  input mode, mode: 0, too_cold: 8, too_hot: 8, fan_on: 0) {
  input logic [7:0] in_,
  output logic [7:0] out;

  // Define the logic for heating mode
 the 1
  assign out = if (mode === 1) ? (in_ < too_cold) ? 1.on() : true : in_ : 1
  else {
    out = false;
  }

  // Define the logic for cooling mode

  if (mode === 0) ? (in_ > too_hot) ? out.on() : true : in_ : in_ : 7:0 : true : 0, 0, 0, 0 : true
  else {
    out = false;
  }

  // Define the logic for fan_on

  if (fan_on) ? out.on() : true : in_ : in_ : 7:0 : 7 0 : 0 : true
  else {
    out = false;
  }

endmodule


```


