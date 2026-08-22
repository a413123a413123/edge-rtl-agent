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
  typedef enum {WALK_LEFT, WALK_RIGHT, FALL_LEFT, FALL_RIGHT, FALLING, DIGGING, SPLATTERED} state_t;
  state_t current_state, next_state;

  // State machine logic
  always @(posedge clk or posedge areset)
  begin
    if (areset)
    begin
      current_state <= WALK_LEFT;
    end
    else
    begin
      current_state <= next_state;
    end
  end

  always @(*)
  begin
    case (current_state)
      WALK_LEFT:
        begin
          if (bump_right)
          begin
            next_state = WALK_RIGHT;
          end
          else if (ground == 0)
          begin
            next_state = FALL_LEFT;
          end
          else if (dig)
          begin
            next_state = DIGGING;
          end
          else
          begin
            next_state = WALK_LEFT;
          end
        end
      WALK_RIGHT:
        begin
          if (bump_left)
          begin
            next_state = WALK_LEFT;
          end
          else if (ground == 0)
          begin
            next_state = FALL_RIGHT;
          end
          else if (dig)
          begin
            next_state = DIGGING;
          end
          else
          begin
            next_state = WALK_RIGHT;
          end
        end
      FALL_LEFT:
        begin
          if (ground == 0)
          begin
            next_state = FALLING;
          end
          else
          begin
            next_state = WALK_LEFT;
          end
        end
      FALL_RIGHT:
        begin
          if (ground == 0)
          begin
            next_state = FALLING;
          end
          else
          begin
            next_state = WALK_RIGHT;
          end
        end
      FALLING:
        begin
          if (ground == 1)
          begin
            next_state = WALK_LEFT;
          end
          else if (dig)
          begin
            next_state = DIGGING;
          end
          else
          begin
            next_state = FALLING;
          end
        end
      DIGGING:
        begin
          if (ground == 1)
          begin
            next_state = DIGGING;
          end
          else
          begin
            next_state = WALK_LEFT;
          end
        end
      SPLATTERED:
        begin
          next_state = SPLATTERED;
        end
    endcase
  end

  // State outputs
  always @(*)
  begin
    walk_left = (current_state == WALK_LEFT);
    walk_right = (current_state == WALK_RIGHT);
    aaah = (current_state == SPLATTERED);
    digging = (current_state == DIGGING);
  end

endmodule
