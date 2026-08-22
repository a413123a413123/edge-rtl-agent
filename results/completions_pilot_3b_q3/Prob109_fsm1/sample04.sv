
module TopModule(
  clk logic [1] in_,
  areset logic [1] reset,
  in_ logic [7:0] in_,
  out_ logic [7:0] out,

  // Combinational logic

  local in_ = clk;


  if reset == 1) {
  in_ = 

  }

  reset = in_ & (in_ ^ 1
  }
  else {
  reset = in_
  }
  }

  if reset == 0 {
  in_ = reset

  }

  in_ = in_
  }

  out = in_
  }

endmodule
