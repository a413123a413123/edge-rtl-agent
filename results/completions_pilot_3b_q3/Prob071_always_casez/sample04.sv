
module TopModule {
  input logic [7:0] in_
  output logic [7:0] out

  // Convert the input to a binary string


  in_binary = input.to_binary_string();

  // Find the first high bit


  high_bit_index = find_first_high_bit(in_binary);



  // Check if the high bit is set



  is_high_bit_set = high_bit_index >= 0

  // Determine the output as the first high bit

  output = out_binary[high_bit_index];



endmodule
