module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // Registers
  reg [1:0] state;

  // State transition logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b10; // Start in state B
    end else begin
      case (state)
        2'b10: begin // State B
          if (in == 0) begin
            state <= 2'b11; // Transition to state A
          end else begin
            state <= 2'b10; // Stay in state B
          end
        end
        2'b11: begin // State A
          if (in == 0) begin
            state <= 2'b00; // Transition to state B
          end else begin
            state <= 2'b11; // Stay in state A
          end
        end
      endcase
    end
  end

  // Output logic
  assign out = state[0];

endmodule
