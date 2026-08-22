
[BEGIN
module
module

TopModule(
  clk (7:0) load (7:0) in_,
  ena (7:0) load (7:0) ena (7:0) amount (7:0) in_,
  q (7:0) out);

  (1) load = ena (7:0) load;

  (2) load = load >> (2:0) >> (c:0) >> (d:0) >> (4:0)
endmodule[DONE]
