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
  typedef enum logic [1:0]
  {
    IDLE,
    FALLING,
    DIGGING,
    SPLATTERING
  } state_t;

  // State variable
  state_t current_state, next_state;

  // Sequential logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= IDLE;
      walk_left <= 1;
      walk_right <= 0;
      aaah <= 0;
      digging <= 0;
    end else begin
      current_state <= next_state;
      case (current_state)
        IDLE:
          if (ground) begin
            if (bump_left) next_state <= WALK_RIGHT;
            else if (bump_right) next_state <= WALK_LEFT;
            else next_state <= DIGGING; // Start digging if on ground
          end else next_state <= FALLING; // Start falling if not on ground

        FALLING:
          if (!ground) next_state <= SPLATTERING; // Splatter if fall
          else next_state <= IDLE; // Resuming walking once on ground

        DIGGING:
          if (ground) next_state <= IDLE; // Stop digging if on ground
          else next_state <= FALLING; // Continue falling

        SPLATTERING:
          // Already in splattering state, do nothing
          break;
      endcase
    end
  end

  // Output logic
  always_comb begin
    walk_left = (current_state == IDLE) ? 1 : 0;
    walk_right = (current_state == IDLE) ? 0 : 1;
    aaah = (current_state == SPLATTERING) ? 1 : 0;
    digging = (current_state == DIGGING) ? 1 : 0;
  end

endmodule
