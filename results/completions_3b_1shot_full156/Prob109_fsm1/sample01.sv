module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // State variables
  logic [0:0] state;

  // State transition logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b1; // Initial state is B
    end else begin
      case (state)
        2'b0: begin
          if (in) begin
            state <= 2'b1; // Transition to B
          end else begin
            state <= 2'b0; // Stay in A
          end
        end
        2'b1: begin
          if (in) begin
            state <= 2'b0; // Transition to A
          end else begin
            state <= 2'b1; // Stay in B
          end
        end
      endcase
    end
  end

  // Output logic
  assign out = state;

endmodule
