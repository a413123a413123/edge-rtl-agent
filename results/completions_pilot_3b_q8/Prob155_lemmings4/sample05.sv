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

  typedef enum logic [1:0]
  {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
  } State_t;

  State_t current_state, next_state;

  always_ff @(posedge clk)
  begin
    if (areset)
      current_state <= WALK_LEFT;
    else
      current_state <= next_state;
  end

  always_comb
  begin
    next_state = current_state;

    walk_left  = 0;
    walk_right = 0;
    aaah      = 0;
    digging    = 0;

    case (current_state)
      WALK_LEFT:
        if (ground)
        begin
          if (bump_right) next_state = WALK_RIGHT;
          if (dig) next_state = DIGGING;
        end
        else
          next_state = FALLING;

      WALK_RIGHT:
        if (ground)
        begin
          if (bump_left) next_state = WALK_LEFT;
          if (dig) next_state = DIGGING;
        end
        else
          next_state = FALLING;

      FALLING:
        if (ground)
        begin
          walk_left  = 1;
          walk_right = 1;
          aaah      = 1;
          digging    = 0;
        end

      DIGGING:
        if (ground) next_state = WALK_RIGHT;
        else
          next_state = FALLING;
    endcase

    if ((current_state == FALLING) && (ground == 1))
      walk_left = 1;
    if ((current_state == FALLING) && (ground == 1))
      walk_right = 1;
    if ((current_state == FALLING) && (ground == 1))
      aaah = 1;
    if ((current_state == FALLING) && (ground == 1))
      digging = 0;
  end

endmodule
