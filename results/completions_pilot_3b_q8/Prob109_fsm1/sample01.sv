module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // Register for the state
  logic state;

  // State transition logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 1'b1; // Initial state is B
    end else begin
      case (state)
        1'b1: if (in == 1'b0) begin
              state <= 1'b0; // Transition to A
            end else begin
              state <= 1'b1; // Stay in B
            end
        1'b0: if (in == 1'b0) begin
              state <= 1'b1; // Transition to B
            end else begin
              state <= 1'b0; // Stay in A
            end
      endcase
    end
  end

  // Output logic
  always_comb begin
    out = (state == 1'b1);
  end

endmodule
