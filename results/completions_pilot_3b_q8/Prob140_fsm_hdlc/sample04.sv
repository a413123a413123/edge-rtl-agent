module TopModule (
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  typedef enum logic [2:0] {
    IDLE = 3'b000,
    ONE = 3'b001,
    TWO = 3'b010,
    THREE = 3'b011,
    FOUR = 3'b100,
    FIVE = 3'b101,
    SIX = 3'b110,
    ERROR = 3'b111
  } state_t;

  state_t curr_state, next_state;
  logic [2:0] count;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      curr_state <= IDLE;
      count <= 0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      curr_state <= next_state;
      count <= count + 1'b1;
      disc <= (curr_state == IDLE && in == 1'b1) ? 1'b1 : 0;
      flag <= (curr_state == IDLE && in == 1'b1 && count == 5) ? 1'b1 : 0;
      err <= (curr_state == IDLE && in == 1'b1 && count == 6) ? 1'b1 : 0;
    end
  end

  always @(*) begin
    case (curr_state)
      IDLE: begin
        next_state = (in == 1'b1) ? ONE : IDLE;
      end
      ONE: begin
        next_state = (in == 1'b1) ? TWO : IDLE;
      end
      TWO: begin
        next_state = (in == 1'b1) ? THREE : IDLE;
      end
      THREE: begin
        next_state = (in == 1'b1) ? FOUR : IDLE;
      end
      FOUR: begin
        next_state = (in == 1'b1) ? FIVE : IDLE;
      end
      FIVE: begin
        next_state = (in == 1'b1) ? SIX : IDLE;
      end
      SIX: begin
        next_state = (in == 1'b1) ? ERROR : IDLE;
      end
      ERROR: begin
        next_state = IDLE;
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

endmodule
