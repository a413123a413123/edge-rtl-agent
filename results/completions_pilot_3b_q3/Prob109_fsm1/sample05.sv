
[BEGIN
TopModule(
  clk input_logic [1:0]
  reset input_reset [0:0]
  in input_bit [0:0]
  out output_bit [0:0]
  if input_reset == high then {
    reset output_bit
  endmodule[DONE]
