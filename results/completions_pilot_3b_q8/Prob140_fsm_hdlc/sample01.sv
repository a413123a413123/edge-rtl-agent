module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  typedef enum {IDLE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, ERROR} state_t;

  state_t current_state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      current_state <= next_state;
      case (current_state)
        IDLE:
          if (in) begin
            next_state <= ONE;
          end else begin
            next_state <= IDLE;
          end
        ONE:
          if (in) begin
            next_state <= TWO;
          end else begin
            next_state <= IDLE;
          end
        TWO:
          if (in) begin
            next_state <= THREE;
          end else begin
            next_state <= IDLE;
          end
        THREE:
          if (in) begin
            next_state <= FOUR;
          end else begin
            next_state <= IDLE;
          end
        FOUR:
          if (in) begin
            next_state <= FIVE;
          end else begin
            next_state <= IDLE;
          end
        FIVE:
          if (in) begin
            next_state <= SIX;
          end else begin
            next_state <= IDLE;
          end
        SIX:
          if (in) begin
            next_state <= SEVEN;
          end else begin
            next_state <= IDLE;
          end
        SEVEN:
          if (in) begin
            next_state <= ERROR;
          end else begin
            next_state <= IDLE;
          end
        ERROR:
          disc <= 0;
          flag <= 0;
          err <= 1;
          next_state <= IDLE;
      endcase
    end
  end

endmodule
