module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic bump_left,
  input  logic bump_right,
  input  logic ground,
  input  logic dig,
  output logic walk_left,
  output logic walk_right,
  output logic aaah,
  output logic digging
);

  // State machine states
  typedef enum {WALK_LEFT, WALK_RIGHT, FALL_LEFT, FALL_RIGHT, FALL_DIG, SPLATTER} state_t;
  state_t current_state, next_state;

  // Sequential logic to update the current state
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
    end else begin
      current_state <= next_state;
    end
  end

  // Combinational logic to determine the next state
  always_comb begin
    case (current_state)
      WALK_LEFT: begin
        next_state = (bump_right) ? WALK_RIGHT : (ground) ? WALK_LEFT : FALL_LEFT;
      end
      WALK_RIGHT: begin
        next_state = (bump_left) ? WALK_LEFT : (ground) ? WALK_RIGHT : FALL_RIGHT;
      end
      FALL_LEFT: begin
        next_state = (bump_right) ? WALK_RIGHT : (ground) ? SPLATTER : FALL_LEFT;
      end
      FALL_RIGHT: begin
        next_state = (bump_left) ? WALK_LEFT : (ground) ? SPLATTER : FALL_RIGHT;
      end
      FALL_DIG: begin
        next_state = (bump_right) ? WALK_RIGHT : (bump_left) ? WALK_LEFT : (ground) ? FALL_DIG : SPLATTER;
      end
      SPLATTER: begin
        next_state = SPLATTER;
      end
      default: begin
        next_state = WALK_LEFT; // Handle undefined state
      end
    endcase
  end

  // Outputs based on the current state
  always_comb begin
    walk_left = (current_state == WALK_LEFT) || (current_state == FALL_LEFT);
    walk_right = (current_state == WALK_RIGHT) || (current_state == FALL_RIGHT);
    aaah = (current_state == SPLATTER);
    digging = (current_state == FALL_DIG);
  end

endmodule
