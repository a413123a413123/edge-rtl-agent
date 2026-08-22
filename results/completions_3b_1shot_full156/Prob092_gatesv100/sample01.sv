module TopModule
(
  input  logic [99:0] in,
  output logic [99:0] out_both,
  output logic [99:0] out_any,
  output logic [99:0] out_different
);

  // Combinational logic

  assign out_both[99] = 0; // No neighbour to the left for in[99]
  assign out_any[0] = 0;   // No neighbour to the right for in[0]

  always_comb begin
    for (int i = 0; i < 99; i++) begin
      out_both[i] = in[i] && in[i + 1];
      out_any[i] = in[i] || in[i + 1];
      out_different[i] = in[i] != in[i + 1];
    end
  end

endmodule
