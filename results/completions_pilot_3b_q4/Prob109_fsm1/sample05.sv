module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  logic next_state;
  logic current_state;

  // State definition
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= 'b0; // Initial state is B
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    next_state = 'b0;
    case (current_state)
      'b0: begin // State B
        next_state = in ? 'b1 : 'b0;
      end
      'b1: begin // State A
        next_state = 'b0;
      end
      default: begin
        next_state = 'b0; // Default case should not be reached
      end
    endcase
  end

  // Output assignment
  assign out = current_state;

endmodule
