module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // Register for the state
  logic [1:0] state;

  // Next state logic
  always @(posedge clk or posedge areset)
  begin
    if (areset)
      state <= 2'b10; // Reset to state B
    else
      case (state)
        2'b00: if (in) state <= 2'b01; else state <= 2'b00;
        2'b01: if (in) state <= 2'b10; else state <= 2'b01;
        2'b10: if (in) state <= 2'b01; else state <= 2'b10;
        default: state <= 2'b00; // This line is technically unreachable
      endcase
  end

  // Output logic
  always @(state)
  begin
    out = (state == 2'b10);
  end

endmodule
