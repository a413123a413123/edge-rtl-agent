
TopModule(
  in  logic [8:0] in_,
  out logic [3:0] out,

  // Combinational logic


  // Calculate the first high bit index

  highBitIndex := in_ == 

  // Initialize the output with the

  output := 0

  // Iterate over each bit of the

  for i in range(0, 8) {
    if in_ & (1 < highBitIndex) {
      output |= (in_ & (1 << i));

      highBitIndex = 

    } else {
      output |= in_
      highBitIndex += 1

    }
  }

  end
module  module
