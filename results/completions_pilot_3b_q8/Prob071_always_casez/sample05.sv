module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Priority encoder logic
  always_comb begin
    pos = 3'b000;
    for (int i = 0; i < 8; i++) begin
      if (in[i]) begin
        pos = i;
        break;
      end
    end
  end

endmodule
