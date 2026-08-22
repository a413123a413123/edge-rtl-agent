module TopModule (
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

  // State definitions
  typedef enum {IDLE, FALL, DIGGING} State;
  State current_state, next_state;

  // Registers
  logic [2:0] fall_counter;

  // Combinational logic
  always_comb begin
    if (areset) begin
      current_state = IDLE;
      walk_left = 1; // Initialize walking left
      walk_right = 0;
      aaah = 0;
      digging = 0;
      fall_counter = 0;
    end else begin
      current_state = next_state;

      // Walk left
      walk_left = (current_state == IDLE || current_state == FALL || current_state == DIGGING) && !bump_right && !dig && !ground;
      walk_right = (current_state == IDLE || current_state == FALL || current_state == DIGGING) && !bump_left && !dig && !ground;

      // Bump logic
      if (bump_left && bump_right)
        walk_left = !walk_left; // Switch direction
      else if (bump_left)
        walk_left = 0;
      else if (bump_right)
        walk_right = 0;

      // Dig logic
      if (dig && ground && !falling) begin
        digging = 1;
        fall_counter = 0;
      end else
        digging = 0;

      // Fall logic
      if (!falling && ground) begin
        fall_counter = 0;
      end else if (falling && !ground) begin
        fall_counter = fall_counter + 1;
        if (fall_counter == 20) begin
          aaah = 1;
          walk_left = 0;
          walk_right = 0;
          digging = 0;
        end
      end else if (falling) begin
        fall_counter = fall_counter + 1;
      end
    end
  end

  // Sequential logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      next_state = IDLE;
    end else begin
      next_state = current_state;
      if (falling && !ground) begin
        next_state = FALL;
      end else if (digging) begin
        next_state = DIGGING;
      end
    end
  end

endmodule
