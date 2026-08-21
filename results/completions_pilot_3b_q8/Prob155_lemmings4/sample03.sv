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
        WALK_LEFT: begin
          if (bump_right) begin
            state <= WALK_RIGHT;
          end else begin
            if (ground) begin
              state <= WALK_LEFT;
            end else begin
              state <= FALL;
              fall_counter <= 0;
            end
          end
        end

        WALK_RIGHT: begin
          if (bump_left) begin
            state <= WALK_LEFT;
          end else begin
            if (ground) begin
              state <= WALK_RIGHT;
            end else begin
              state <= FALL;
              fall_counter <= 0;
            end
          end
        end

        FALL: begin
          if (ground) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
          end else begin
            fall_counter <= fall_counter + 1;
            if (fall_counter == 20) begin
              state <= SPLATTER;
            end
          end
        end

        DIGGING: begin
          if (ground) begin
            state <= DIGGING;
          end else begin
            state <= WALK_LEFT;
          end
        end

        SPLATTER: begin
          walk_left <= 0;
          walk_right <= 0;
          aaah <= 0;
          digging <= 0;
        end
      endcase
    end
  end

  // Outputs
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah = (state == SPLATTER);
  assign digging = (state == DIGGING || state == SPLATTER);

endmodule
