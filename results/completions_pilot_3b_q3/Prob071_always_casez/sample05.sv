
[BEGIN
TopModule(
  in_ input 8 bits)

  out_ output 3 bits

  // Initialize the result as the input

  var out = in_;

  // Check if the first bit is set

  if (out & 1 === 1) {
    // Return the first set bit

    out & 1
  } else {
    // Return zero
    

  endmodule[DONE]
