module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Array of signals indicating the position of high bits
  logic [7:0] pos_array = 8'b00000000;

  // Priority encoder logic
  assign pos_array[0] = in[0];
  assign pos_array[1] = (in[1] && !pos_array[0]);
  assign pos_array[2] = (in[2] && !pos_array[1]);
  assign pos_array[3] = (in[3] && !pos_array[2]);
  assign pos_array[4] = (in[4] && !pos_array[3]);
  assign pos_array[5] = (in[5] && !pos_array[4]);
  assign pos_array[6] = (in[6] && !pos_array[5]);
  assign pos_array[7] = (in[7] && !pos_array[6]);

  // Find the index of the first high bit
  always @(posedge in) begin
    pos = 3'b0;
    for (int i = 0; i < 8; i++) begin
      if (pos_array[i]) begin
        pos = i;
        break;
      end
    end
  end

endmodule
