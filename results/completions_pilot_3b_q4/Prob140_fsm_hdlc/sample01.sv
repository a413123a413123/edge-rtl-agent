module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  // State machine
  typedef enum {IDLE, START, ONE, TWO, THREE, FOUR, FIVE, SIX} state_t;
  state_t current_state, next_state;

  // State register
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    next_state = current_state;

    // Start condition
    case (current_state)
      IDLE: if (in) next_state = START;
      START: if (in) next_state = ONE;
      ONE: if (in) next_state = TWO;
      TWO: if (in) next_state = THREE;
      THREE: if (in) next_state = FOUR;
      FOUR: if (in) next_state = FIVE;
      FIVE: if (in) next_state = SIX;
      SIX: if (in) begin next_state = IDLE; disc = 0; flag = 0; err = 0; end
      default: next_state = IDLE;
    endcase

    // Error condition
    if (in) begin
      case (current_state)
        START, ONE, TWO, THREE, FOUR, FIVE, SIX: err = 1;
        default: err = 0;
      endcase
    end else begin
      err = 0;
    end

    // Discard condition
    case (current_state)
      START: if (in) begin next_state = IDLE; disc = 1; flag = 0; err = 0; end
      ONE: if (in) begin next_state = IDLE; disc = 1; flag = 0; err = 0; end
      TWO: if (in) begin next_state = IDLE; disc = 1; flag = 0; err = 0; end
      THREE: if (in) begin next_state = IDLE; disc = 1; flag = 0; err = 0; end
      FOUR: if (in) begin next_state = IDLE; disc = 1; flag = 0; err = 0; end
      FIVE: if (in) begin next_state = IDLE; disc = 1; flag = 0; err = 0; end
      SIX: if (in) begin next_state = IDLE; disc = 1; flag = 0; err = 0; end
      default: disc = 0;
    endcase

    // Flag condition
    case (current_state)
      START, ONE, TWO, THREE, FOUR, FIVE, SIX: flag = 1;
      default: flag = 0;
    endcase
  end

endmodule
