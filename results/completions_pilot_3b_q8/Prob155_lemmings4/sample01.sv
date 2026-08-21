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

  // State register and next state logic
  state_t state, next_state;

  // Counter for falling duration
  logic [5:0] fall_counter;

  // Register to track falling status
  logic falling;

  // Register to track splattering status
  logic splattering;

  // Next state determination
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= IDLE;
      walk_left <= 1'b0;
      walk_right <= 1'b0;
      aaah <= 1'b0;
      digging <= 1'b0;
      fall_counter <= 0;
      falling <= 1'b0;
      splattering <= 1'b0;
    end else begin
      state <= next_state;
      walk_left <= (state == IDLE || state == FALLING) ? 1'b1 : 1'b0;
      walk_right <= (state == IDLE || state == FALLING) ? 1'b0 : 1'b1;
      aaah <= (state == FALLING || state == SPLATTERING) ? 1'b1 : 1'b0;
      digging <= (state == IDLE || state == FALLING) ? dig : 1'b0;

      // Update falling status
      if (falling) begin
        fall_counter <= fall_counter + 1;
      end

      // Update splattering status
      if (fall_counter == 20 && ground) begin
        splattering <= 1'b1;
        fall_counter <= 0;
        falling <= 1'b0;
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
      end

      // State transitions
      case (state)
        IDLE: begin
          if (bump_left || bump_right) begin
            next_state = (bump_left) ? IDLE : IDLE; // Change direction
          end else if (ground) begin
            if (dig) begin
              next_state = DIGGING;
            end else begin
              next_state = IDLE;
            end
          end else begin
            next_state = FALLING;
          end
        end
        FALLING: begin
          if (bump_left || bump_right) begin
            next_state = (bump_left) ? IDLE : IDLE; // Change direction
          end else if (ground) begin
            next_state = IDLE;
          end else begin
            next_state = FALLING;
          end
        end
        DIGGING: begin
          if (bump_left || bump_right) begin
            next_state = (bump_left) ? IDLE : IDLE; // Change direction
          end else if (!ground) begin
            next_state = IDLE;
          end else begin
            next_state = DIGGING;
          end
        end
        SPLATTERING: begin
          next_state = IDLE;
        end
      endcase
    end
  end

endmodule
