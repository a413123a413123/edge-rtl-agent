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
  enum {WALK_LEFT, WALK_RIGHT, FALL, DIGGING, SPLATTER} state;

  // Internal signals
  logic fall_counter;

  // Reset
  always_ff @(posedge areset) begin
    state <= WALK_LEFT;
    fall_counter <= 0;
    walk_left <= 1;
    walk_right <= 0;
    aaah <= 0;
    digging <= 0;
  end

  // State machine
  always_ff @(posedge clk) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_counter <= 0;
      walk_left <= 1;
      walk_right <= 0;
      aaah <= 0;
      digging <= 0;
    end else begin
      case (state)
        WALK_LEFT:
          if (bump_right)
            state <= WALK_RIGHT;
          else if (ground)
            if (dig)
              state <= DIGGING;
            else if (bump_left)
              state <= WALK_RIGHT;
            else if (fall_counter == 20)
              state <= SPLATTER;
            else
              state <= WALK_LEFT;
          else
            state <= FALL;
        WALK_RIGHT:
          if (bump_left)
            state <= WALK_LEFT;
          else if (ground)
            if (dig)
              state <= DIGGING;
            else if (bump_right)
              state <= WALK_LEFT;
            else if (fall_counter == 20)
              state <= SPLATTER;
            else
              state <= WALK_RIGHT;
          else
            state <= FALL;
        FALL:
          fall_counter <= fall_counter + 1;
          if (ground)
            state <= WALK_LEFT;
          else if (fall_counter == 20)
            state <= SPLATTER;
          else
            state <= FALL;
        DIGGING:
          fall_counter <= 0;
          if (bump_left)
            state <= WALK_RIGHT;
          else if (bump_right)
            state <= WALK_LEFT;
          else if (ground)
            state <= WALK_LEFT;
          else if (fall_counter == 20)
            state <= SPLATTER;
          else
            state <= DIGGING;
        SPLATTER:
          state <= SPLATTER;
      endcase
    end
  end

  // Outputs
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah = (state == SPLATTER);
  assign digging = (state != SPLATTER);

endmodule
