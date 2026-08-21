module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  always @(*) begin
    pos = 3'b0;

    for (int i = 0; i < 8; i++) begin
      if (in[i] == 1)
        pos = i;
    end
  end

endmodule
