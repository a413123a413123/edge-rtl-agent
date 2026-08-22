
module

module TopModule(
  mode [7:0],
 in_ [7:0], too_cold [7:0], too_hot [7:0], fan_on [7:0], heater [7:0], aircon [7:0], fan [7:0], out [7:0]
  assign mode = in_
  if (mode == 1) {
    assign heater = true

    assign aircon = true

  } else if (mode == 0) {
    assign heater = true

    assign aircon = false
    } else {
    assign heater = false

    assign aircon = false

  }

  if (too_cold <=  
    assign heater = false

    assign aircon = true

  } else {
    assign heater = false

    assign aircon = false

  }
  if (too_hot <= 0)
    assign heater = true

    assign aircon = false

  } else {
    assign heater = false

    assign aircon = false

  }
  assign out = out + 1

endmodule

```
