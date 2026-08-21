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
  localparam STATE_WALK_LEFT = 2'b00;
  localparam STATE_WALK_RIGHT = 2'b01;
  localparam STATE_FALL_LEFT = 2'b10;
  localparam STATE_FALL_RIGHT = 2'b11;
  localparam STATE_FALLING = 2'b11;

  // State registers
  logic [1:0] state;

  // Signals
  logic [20:0] fall_counter;

  // State machine
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= STATE_WALK_LEFT;
      walk_left <= 1'b1;
      walk_right <= 1'b0;
      aaah <= 1'b0;
      digging <= 1'b0;
      fall_counter <= 20'b0;
    end else begin
      case (state)
        STATE_WALK_LEFT: begin
          if (bump_right) begin
            state <= STATE_WALK_RIGHT;
            walk_left <= 1'b0;
            walk_right <= 1'b1;
          end else if (ground && !digging && !fall_counter) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
          end
        end
        STATE_WALK_RIGHT: begin
          if (bump_left) begin
            state <= STATE_WALK_LEFT;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
          end else if (ground && !digging && !fall_counter) begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
          end
        end
        STATE_FALL_LEFT: begin
          if (dig && ground) begin
            fall_counter <= 20'b0;
            state <= STATE_DIGGING;
          end else if (fall_counter < 20) begin
            fall_counter <= fall_counter + 1;
          end else if (!ground) begin
            state <= STATE_FALLING;
          end
        end
        STATE_FALL_RIGHT: begin
          if (dig && ground) begin
            fall_counter <= 20'b0;
            state <= STATE_DIGGING;
          end else if (fall_counter < 20) begin
            fall_counter <= fall_counter + 1;
          end else if (!ground) begin
            state <= STATE_FALLING;
          end
        end
        STATE_FALLING: begin
          if (fall_counter < 20) begin
            fall_counter <= fall_counter + 1;
          end else if (!ground) begin
            state <= STATE_WALK_LEFT;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
          end
        end
        STATE_DIGGING: begin
          if (!ground) begin
            state <= STATE_FALL_LEFT;
          end
        end
      endcase
    end
  end

  // Output assignments
  assign aaah = ground & !digging & !fall_counter;
  assign digging = (state == STATE_DIGGING) | (state == STATE_FALLING);
  assign walk_left = (state == STATE_WALK_LEFT) | (state == STATE_FALL_LEFT) | (state == STATE_DIGGING);
  assign walk_right = (state == STATE_WALK_RIGHT) | (state == STATE_FALL_RIGHT) | (state == STATE_DIGGING);

endmodule
