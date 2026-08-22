module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Combinational logic

  always_comb
  begin
    pos = 3'b0;
    for (int i = 0; i < 8; i++)
      if (in[i])
        pos = i;
  end

endmodule
