module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Declare state variables
  logic [1:0] state;

  // Initial state
  always_ff @(posedge clk or posedge areset)
    if (areset)
      state <= 2'b00;
    else
      state <= state;

  // Mealy state machine
  always_ff @(posedge clk)
  begin
    case (state)
      2'b00: begin
        if (x)
          z <= 1'b1;
        else
          z <= 1'b0;
        state <= 2'b00; // Stay in A
      end
      2'b01: begin
        if (x)
          z <= 1'b0;
        else
          z <= 1'b1;
        state <= 2'b10; // Transition to B
      end
      2'b10: begin
        if (x)
          z <= 1'b1;
        else
          z <= 1'b0;
        state <= 2'b10; // Stay in B
      end
    endcase
  end

endmodule
