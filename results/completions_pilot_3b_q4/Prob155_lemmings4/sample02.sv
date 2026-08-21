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
  enum {LEFT, RIGHT, FALLING, DIGGING} current_state, next_state;

  // Reset the FSM
  always @(posedge areset) begin
    current_state <= LEFT;
  end

  // Next state logic
  always @(posedge clk) begin
    current_state <= next_state;
  end

  // State transition table
  always_comb begin
    next_state = current_state;

    // Left walking
    if (current_state == LEFT) begin
      if (bump_right) next_state = RIGHT;
      if (dig && ground) next_state = DIGGING;
      if (ground) next_state = LEFT;
    end

    // Right walking
    if (current_state == RIGHT) begin
      if (bump_left) next_state = LEFT;
      if (dig && ground) next_state = DIGGING;
      if (ground) next_state = RIGHT;
    end

    // Falling
    if (current_state == FALLING) begin
      if (ground) next_state = LEFT;
      if (ground) next_state = RIGHT;
    end

    // Digging
    if (current_state == DIGGING) begin
      if (dig && ground) next_state = DIGGING;
      if (ground) next_state = LEFT;
      if (ground) next_state = RIGHT;
    end
  end

  // Output logic
  assign walk_left = (current_state == LEFT);
  assign walk_right = (current_state == RIGHT);
  assign aaah = (current_state == FALLING);
  assign digging = (current_state == DIGGING);

endmodule
