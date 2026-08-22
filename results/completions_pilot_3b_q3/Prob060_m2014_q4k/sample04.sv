
TopModule(
  clk logic [1:1] in_,
  resetn logic [1:0] resetn,

  in logic [1:1] in_,
  out logic [1:1] out

  // Combinational logic

  var top_register = Verilog::Register(
    clk: clk,

    resetn: resetn,
    in: in,

    out: out


endmodule
