module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic bump_left,
  input  logic bump_right,
  input  logic ground,
  output logic walk_left,
  output logic walk_right,
  output logic aaah
);

  // State definitions
  localparam IDLE = 2'b00;
  localparam WALK_LEFT = 2'b01;
  localparam WALK_RIGHT = 2'b10;
  localparam FALL = 2'b11;

  // State register
  logic [1:0] state;

  // Next state logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (ground) begin
            state <= WALK_LEFT;
          end else begin
            state <= FALL;
          end
        end
        WALK_LEFT: begin
          if (bump_right) begin
            state <= WALK_RIGHT;
          end else if (ground) begin
            state <= WALK_LEFT;
          end else begin
            state <= FALL;
          end
        end
        WALK_RIGHT: begin
          if (bump_left) begin
            state <= WALK_LEFT;
          end else if (ground) begin
            state <= WALK_RIGHT;
          end else begin
            state <= FALL;
          end
        end
        FALL: begin
          if (ground) begin
            state <= WALK_LEFT;
          end else begin
            state <= FALL;
          end
        end
      endcase
    end
  end

  // Output logic
  always @(state) begin
    walk_left <= (state == WALK_LEFT);
    walk_right <= (state == WALK_RIGHT);
    aaah <= (state == FALL);
  end

endmodule
