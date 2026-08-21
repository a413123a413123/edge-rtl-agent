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

  // State machine variables
  enum {WALK_LEFT, WALK_RIGHT, FALL, DIGGING, SPLATTER} state;

  // Next state logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_left <= 1;
      walk_right <= 0;
      aaah <= 0;
      digging <= 0;
    end else begin
      case (state)
        WALK_LEFT: begin
          if (bump_right) begin
            state <= WALK_RIGHT;
            walk_left <= 0;
            walk_right <= 1;
          end else if (ground && !dig) begin
            state <= WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
          end else if (!ground) begin
            state <= FALL;
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
          end else if (dig) begin
            state <= DIGGING;
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
          end else if (bump_left && bump_right) begin
            state <= WALK_RIGHT;
            walk_left <= 0;
            walk_right <= 1;
          end
        end
        WALK_RIGHT: begin
          if (bump_left) begin
            state <= WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
          end else if (ground && !dig) begin
            state <= WALK_RIGHT;
            walk_left <= 0;
            walk_right <= 1;
          end else if (!ground) begin
            state <= FALL;
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
          end else if (dig) begin
            state <= DIGGING;
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
          end else if (bump_left && bump_right) begin
            state <= WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
          end
        end
        FALL: begin
          if (ground) begin
            state <= WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
          end else if (dig) begin
            state <= DIGGING;
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
          end
        end
        DIGGING: begin
          if (!ground) begin
            state <= FALL;
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
          end
        end
        SPLATTER: begin
          // No further state changes
        end
      endcase
    end
  end

  // Output logic
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah = (state == SPLATTER);
  assign digging = (state == SPLATTER);

endmodule
