
TopModule(
  input clk [1:1] load,
  input ena [2:0] ena

  input amount [2:0] amount

  input data [4:8] data
  output q [4:8] q
  ena = input ena;
  amount
  amount = input amount

  q = (input data & 1 << 8 - input amount & 1 >> 8)
  input amount <= 8
  q = q >> 8 - (input_amount >> 1
  shift = (input_amount & 1) >= 8
  shift = shift - (input_amount >> 1
  amount 1
  if (shift == "l")
  ) then q = (q >> 8 - 1 >> 8) & q = (q >> 8 - 1 >> 8) + input_data[63:0])
  else if (shift == "r") then q = (q >> 8 - 1 >> 8) & q = (q >> 8 - 1 >> 8) + input_data[63:0] - 1 >> 8)
  else {
    q = input_data[63:0]
  }

endmodule
 
