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

  logic [2:0] state;

  // State transitions
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 3'b000; // Start in walk left
    end else begin
      case (state)
        3'b000: // Walk left
          if (bump_left) begin
            state <= 3'b001; // Walk right
          end else if (ground) begin
            state <= 3'b000; // Stay in walk left
          end else begin
            state <= 3'b002; // Fall
          end
        3'b001: // Walk right
          if (bump_right) begin
            state <= 3'b000; // Walk left
          end else if (ground) begin
            state <= 3'b001; // Stay in walk right
          end else begin
            state <= 3'b002; // Fall
          end
        3'b002: // Fall
          if (!ground) begin
            state <= 3'b010; // Start digging
          end else begin
            state <= 3'b002; // Continue falling
          end
        3'b010: // Dig
          if (!ground) begin
            state <= 3'b010; // Continue digging
          end else begin
            state <= 3'b000; // Finish digging, start walking
          end
        default: begin
          state <= 3'b000; // Reset
        end
      endcase
    end
  end

  // State actions
  always @(posedge clk) begin
    case (state)
      3'b000: begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
      end
      3'b001: begin
        walk_left <= 1'b0;
        walk_right <= 1'b1;
        aaah <= 1'b0;
        digging <= 1'b0;
      end
      3'b002: begin
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        aaah <= 1'b1;
        digging <= 1'b0;
      end
      3'b010: begin
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b1;
      end
      default: begin
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
      end
    endcase
  end

endmodule
