module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Array of registers for holding the position
  logic [2:0] pos_array[7:0];

  // Initialization of the position array
  initial begin
    for (int i = 0; i < 8; i++) begin
      pos_array[i] = i;
    end
  end

  // Combinational logic to find the first '1'
  always_comb begin
    if (in[0]) pos = pos_array[0];
    else if (in[1]) pos = pos_array[1];
    else if (in[2]) pos = pos_array[2];
    else if (in[3]) pos = pos_array[3];
    else if (in[4]) pos = pos_array[4];
    else if (in[5]) pos = pos_array[5];
    else if (in[6]) pos = pos_array[6];
    else if (in[7]) pos = pos_array[7];
  end

endmodule
