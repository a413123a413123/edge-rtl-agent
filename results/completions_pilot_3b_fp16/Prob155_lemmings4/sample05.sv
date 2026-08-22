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

  always_ff @(posedge clk, posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
      walk_left <= 1'b1;
      walk_right <= 1'b0;
      aaah <= 1'b0;
      digging <= 1'b0;
    end else begin
      current_state <= next_state;
      walk_left <= (current_state == WALK_LEFT || current_state == DIGGING) && !ground;
      walk_right <= (current_state == WALK_RIGHT || current_state == DIGGING) && !ground;
      aaah <= current_state == FALLING;
      digging <= current_state == DIGGING && ground;
    end
  end

  always_comb begin
    case (current_state)
      WALK_LEFT: begin
        next_state = (ground || bump_right) ? WALK_RIGHT : (bump_left) ? FALLING : WALK_LEFT;
      end
      WALK_RIGHT: begin
        next_state = (ground || bump_left) ? WALK_LEFT : (bump_right) ? FALLING : WALK_RIGHT;
      end
      FALLING: begin
        if (aaah) begin
          next_state = WALK_LEFT;
        end else if (fall_time >= 20) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = FALLING;
        end
      end
      DIGGING: begin
        next_state = (dig && ground) ? WALK_LEFT : (dig && !ground) ? FALLING : DIGGING;
      end
      default: begin
        next_state = WALK_LEFT;
      end
    endcase
  end

  logic [3:0] fall_time;

  always_ff @(posedge clk) begin
    if (fall_time < 20) begin
      fall_time <= fall_time + 1;
    end else if (ground) begin
      fall_time <= 0;
    end
  end

endmodule
