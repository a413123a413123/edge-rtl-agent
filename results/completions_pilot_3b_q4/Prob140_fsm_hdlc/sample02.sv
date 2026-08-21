module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  // State definitions
  typedef enum { IDLE, FIVE_ONES, SIX_ONES, SEVEN_ONES } state_t;
  state_t current_state = IDLE;
  state_t next_state;

  // Combinational logic
  always_comb begin
    case (current_state)
      IDLE: begin
        if (in) begin
          next_state = FIVE_ONES;
        end else begin
          next_state = IDLE;
        end
      end
      FIVE_ONES: begin
        if (in) begin
          next_state = SIX_ONES;
        end else begin
          next_state = IDLE;
        end
      end
      SIX_ONES: begin
        if (in) begin
          next_state = SEVEN_ONES;
        end else begin
          next_state = IDLE;
        end
      end
      SEVEN_ONES: begin
        disc = 1'b1;
        err = 1'b1;
        next_state = IDLE;
      end
    endcase
  end

  // Register the next state
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

endmodule
