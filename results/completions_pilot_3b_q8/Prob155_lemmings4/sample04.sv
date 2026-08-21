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
  typedef enum {IDLE, FALLING, DIGGER, SPLATTERED} State;
  State current_state, next_state;

  // Current state variables
  logic [2:0] fall_count;
  logic [2:0] dig_count;

  // Initial state
  initial begin
    current_state = IDLE;
  end

  // State transitions
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= IDLE;
      fall_count <= 0;
      dig_count <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == IDLE) begin
        if (ground) begin
          if (dig) begin
            next_state <= DIGGER;
            dig_count <= 0;
          end else if (bump_left || bump_right) begin
            next_state <= IDLE;
          end else begin
            walk_left <= 0;
            walk_right <= 1;
          end
        end else begin
          walk_left <= 1;
          walk_right <= 0;
        end
      end else if (current_state == FALLING) begin
        if (ground) begin
          next_state <= IDLE;
        end else begin
          fall_count <= fall_count + 1;
          if (fall_count == 20) begin
            current_state <= SPLATTERED;
          end
        end
      end else if (current_state == DIGGER) begin
        if (!ground) begin
          next_state <= IDLE;
        end else if (fall_count == 0) begin
          next_state <= IDLE;
        end else begin
          dig_count <= dig_count + 1;
        end
      end else if (current_state == SPLATTERED) begin
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
      end
    end
  end

  // Output assignments
  assign walk_left = (current_state == IDLE) ? (bump_left ? 1 : 0) : 0;
  assign walk_right = (current_state == IDLE) ? (bump_right ? 0 : 1) : 0;
  assign aaah = (current_state == FALLING) ? 1 : 0;
  assign digging = (current_state == DIGGER) ? 1 : 0;

endmodule
