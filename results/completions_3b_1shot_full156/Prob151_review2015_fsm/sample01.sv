module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic data,
  input  logic done_counting,
  input  logic ack,
  output logic shift_ena,
  output logic counting,
  output logic done
);

  // State machine
  typedef enum {IDLE, START, COUNT, DONE} state_t;
  state_t current_state, next_state;

  // Internal signals
  logic [3:0] count;
  logic [3:0] pattern = 4'b1101;

  // State machine logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
      count <= 4'b0;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      current_state <= next_state;

      case (current_state)
        IDLE: begin
          if (data == pattern) begin
            next_state <= START;
          end else begin
            next_state <= IDLE;
          end
        end

        START: begin
          shift_ena <= 1'b1;
          next_state <= COUNT;
        end

        COUNT: begin
          if (count == 4'b1111) begin
            next_state <= DONE;
          end else begin
            count <= count + 1'b1;
            next_state <= COUNT;
          end
        end

        DONE: begin
          done <= 1'b1;
          next_state <= IDLE;
        end
      endcase
    end
  end

endmodule
