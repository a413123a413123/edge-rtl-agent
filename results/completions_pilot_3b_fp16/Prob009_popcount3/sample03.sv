module TopModule
(
  input  logic [2:0] in,
  output logic [1:0] out
);

  // Count the number of '1's in the input vector

  logic count = 0;

  always @(*) begin
    count = 0;
    for (int i = 0; i < 3; i++) begin
      if (in[i]) begin
        count = count + 1;
      end
    end
  end

  assign out = count;

endmodule
