module TopModule (
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  // Sequential logic

  enum {IDLE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN} state;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      case (state)
        IDLE:
          if (in)
            state <= ONE;
          else
            state <= IDLE;
        ONE:
          if (in)
            state <= TWO;
          else
            state <= IDLE;
        TWO:
          if (in)
            state <= THREE;
          else
            state <= IDLE;
        THREE:
          if (in)
            state <= FOUR;
          else
            state <= IDLE;
        FOUR:
          if (in)
            state <= FIVE;
          else
            state <= IDLE;
        FIVE:
          if (in)
            state <= SIX;
          else
            state <= IDLE;
        SIX:
          if (in)
            state <= SEVEN;
          else
            state <= IDLE;
        SEVEN:
          if (in)
            state <= SEVEN;
          else begin
            disc <= 1;
            flag <= 1;
            err <= 1;
          end
      endcase
    end
  end

  assign disc = (state == SEVEN) & (in == 0);
  assign flag = (state == SEVEN) & (in == 1);

endmodule
