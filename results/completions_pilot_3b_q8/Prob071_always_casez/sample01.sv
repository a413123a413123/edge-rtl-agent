module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Combinational logic

  always_comb begin
    pos = 3'b0;
    for (int i = 7; i >= 0; i--) begin
      if (in[i]) begin
        pos = i;
        break;
      end
    end
  end

endmodule
