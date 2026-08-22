module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic bump_left,
  input  logic bump_right,
  output logic walk_left,
  output logic walk_right
);

  // Internal states
  logic [1:0] state;

  // State machine
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // Initial state: walk left
    end else begin
      case (state)
        2'b00: begin // walk left
          if (bump_right) begin
            state <= 2'b01; // Walk right
          end
        end
        2'b01: begin // walk right
          if (bump_left) begin
            state <= 2'b00; // Walk left
          end
        end
      endcase
    end
  end

  // Output logic
  assign walk_left = (state == 2'b00);
  assign walk_right = (state == 2'b01);

endmodule
