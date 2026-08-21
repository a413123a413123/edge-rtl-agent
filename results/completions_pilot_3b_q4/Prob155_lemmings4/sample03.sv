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

  // States
  parameter ST_WALK_LEFT = 2'b00;
  parameter ST_WALK_RIGHT = 2'b01;
  parameter ST_FALLING = 2'b10;
  parameter ST_DIGGING = 2'b11;

  // Current state
  logic [1:0] current_state;

  // Next state
  logic [1:0] next_state;

  // Temporary variables
  logic ground_changed;
  logic dig_completed;
  logic splatted;

  // Next state logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= ST_WALK_LEFT;
      next_state <= ST_WALK_LEFT;
      ground_changed <= 0;
      dig_completed <= 0;
      splatted <= 0;
    end else begin
      next_state = current_state;
      ground_changed = ground != current_state[1];
      dig_completed = ground == 0;

      case (current_state)
        ST_WALK_LEFT: begin
          if (ground) begin
            if (bump_right) begin
              next_state = ST_WALK_RIGHT;
            end else if (bump_left) begin
              next_state = ST_FALLING;
            end
          end else if (dig) begin
            next_state = ST_DIGGING;
          end
        end
        ST_WALK_RIGHT: begin
          if (ground) begin
            if (bump_left) begin
              next_state = ST_WALK_LEFT;
            end else if (bump_right) begin
              next_state = ST_FALLING;
            end
          end else if (dig) begin
            next_state = ST_DIGGING;
          end
        end
        ST_FALLING: begin
          if (ground) begin
            next_state = ST_WALK_LEFT;
            next_state = ST_WALK_RIGHT;
            next_state = ST_DIGGING;
            splatted <= 1;
          end
        end
        ST_DIGGING: begin
          if (ground) begin
            next_state = ST_WALK_LEFT;
            next_state = ST_WALK_RIGHT;
            next_state = ST_FALLING;
            dig_completed <= 1;
          end
        end
      endcase
    end
  end

  // State assignments
  always @(next_state) begin
    case (next_state)
      ST_WALK_LEFT: begin
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
      end
      ST_WALK_RIGHT: begin
        walk_left <= 0;
        walk_right <= 1;
        aaah <= 0;
        digging <= 0;
      end
      ST_FALLING: begin
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 1;
        digging <= 0;
      end
      ST_DIGGING: begin
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 0;
        digging <= 1;
      end
    endcase
  end

  // Splatter logic
  always @(ground or splatted) begin
    if (ground) begin
      splatted <= 0;
    end
  end

endmodule
