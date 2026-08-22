module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Registers
  logic [1:0] state;

  // Combinational logic
  always_ff @(posedge clk or posedge areset)
    if (areset) state <= 2'b00; // Reset into state A
    else
      case (state)
        2'b00: state <= (x ? 2'b01 : 2'b00); // A --x=0 (z=0)--> A
        2'b01: state <= (x ? 2'b10 : 2'b01); // A --x=1 (z=1)--> B
        2'b10: state <= (x ? 2'b10 : 2'b01); // B --x=0 (z=1)--> B
        2'b11: state <= (x ? 2'b00 : 2'b11); // B --x=1 (z=0)--> B
      endcase

  // Output logic
  assign z = (state == 2'b11) ? ~x : x; // z is the inverse of x when state is B

endmodule
