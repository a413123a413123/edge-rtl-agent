module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  enum {IDLE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, ERROR} state;
  logic [0:0] count;
  logic [0:0] count1;
  logic [0:0] count2;
  logic [0:0] count3;
  logic [0:0] count4;
  logic [0:0] count5;
  logic [0:0] count6;

  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= IDLE;
    else begin
      case (state)
        IDLE:
          if (in == 1) begin
            count <= 1;
            state <= ONE;
          end
        ONE:
          if (in == 1) begin
            count <= count + 1;
            state <= TWO;
          end else
            state <= IDLE;
        TWO:
          if (in == 1) begin
            count <= count + 1;
            state <= THREE;
          end else
            state <= IDLE;
        THREE:
          if (in == 1) begin
            count <= count + 1;
            state <= FOUR;
          end else
            state <= IDLE;
        FOUR:
          if (in == 1) begin
            count <= count + 1;
            state <= FIVE;
          end else
            state <= IDLE;
        FIVE:
          if (in == 1) begin
            count <= count + 1;
            state <= SIX;
          end else
            state <= IDLE;
        SIX:
          if (in == 1) begin
            count <= count + 1;
            if (count == 6) begin
              count6 <= 1;
              state <= IDLE;
              disc <= 1;
            end
          end else
            state <= IDLE;
        SEVEN:
          if (in == 1) begin
            count <= count + 1;
            count7 <= 1;
            state <= IDLE;
            err <= 1;
          end
        ERROR:
          if (in == 1) begin
            state <= IDLE;
            err <= 1;
          end
      endcase
    end
  end

endmodule
