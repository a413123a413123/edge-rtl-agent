module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  // Define the states
  typedef enum {
    IDLE,
    CONSECUTIVE_1S,
    ERROR
  } state_t;

  // State register and next state logic
  state_t state = IDLE;
  state_t next_state;

  // Output signals
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      state <= next_state;
      disc <= 0;
      flag <= 0;
      err <= 0;

      case (state)
        IDLE: begin
          if (in == 1) begin
            next_state = CONSECUTIVE_1S;
          end else begin
            next_state = IDLE;
          end
        end

        CONSECUTIVE_1S: begin
          if (in == 1) begin
            if (num_consecutive_1s == 5) begin
              disc <= 1;
              next_state = IDLE;
            end else begin
              if (num_consecutive_1s == 6) begin
                flag <= 1;
                next_state = IDLE;
              end else begin
                num_consecutive_1s <= num_consecutive_1s + 1;
                next_state = CONSECUTIVE_1S;
              end
            end
          end else begin
            if (num_consecutive_1s >= 7) begin
              err <= 1;
              next_state = ERROR;
            end else begin
              num_consecutive_1s <= 0;
              next_state = IDLE;
            end
          end
        end

        ERROR: begin
          if (in == 1) begin
            next_state = ERROR;
          end else begin
            next_state = IDLE;
          end
        end
      endcase
    end
  end

  // Count consecutive 1s
  reg [4:0] num_consecutive_1s;

endmodule
