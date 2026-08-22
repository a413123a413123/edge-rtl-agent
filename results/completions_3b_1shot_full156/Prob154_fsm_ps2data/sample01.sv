module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] in,
  output logic [23:0] out_bytes,
  output logic done
);

  // State machine
  typedef enum {IDLE, WAIT_FOR_START, RECEIVE_BYTE1, RECEIVE_BYTE2, RECEIVE_BYTE3} state_t;
  state_t current_state, next_state;

  // Buffer to store received bytes
  logic [7:0] byte_buffer[2];

  // Flags to indicate when to output the message
  logic byte1_received, byte2_received, byte3_received;

  // Register to hold the current byte
  logic [7:0] current_byte;

  // Register to hold the output bytes
  logic [23:0] output_bytes_reg;

  // Register to hold the done signal
  logic done_reg;

  // Next state logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
      byte_buffer <= {8'b0, 8'b0, 8'b0};
      byte1_received <= 0;
      byte2_received <= 0;
      byte3_received <= 0;
      current_byte <= 8'b0;
      output_bytes_reg <= 24'b0;
      done_reg <= 0;
    end else begin
      current_state <= next_state;
      byte_buffer <= byte_buffer;
      byte1_received <= byte1_received;
      byte2_received <= byte2_received;
      byte3_received <= byte3_received;
      current_byte <= current_byte;
      output_bytes_reg <= output_bytes_reg;
      done_reg <= done_reg;
    end
  end

  // State transition logic
  always @(current_state, in) begin
    case (current_state)
      IDLE: begin
        if (in[3]) begin
          next_state <= WAIT_FOR_START;
        end else begin
          next_state <= IDLE;
        end
      end
      WAIT_FOR_START: begin
        if (in[3]) begin
          next_state <= RECEIVE_BYTE1;
        end else begin
          next_state <= WAIT_FOR_START;
        end
      end
      RECEIVE_BYTE1: begin
        if (in[3]) begin
          byte_buffer[0] <= in;
          next_state <= RECEIVE_BYTE2;
        end else begin
          next_state <= WAIT_FOR_START;
        end
      end
      RECEIVE_BYTE2: begin
        if (in[3]) begin
          byte_buffer[1] <= in;
          next_state <= RECEIVE_BYTE3;
        end else begin
          next_state <= WAIT_FOR_START;
        end
      end
      RECEIVE_BYTE3: begin
        if (in[3]) begin
          byte_buffer[2] <= in;
          next_state <= IDLE;
          byte1_received <= 1;
          byte2_received <= 1;
          byte3_received <= 1;
        end else begin
          next_state <= WAIT_FOR_START;
        end
      end
    endcase
  end

  // Output logic
  always @(current_state, byte_buffer, byte1_received, byte2_received, byte3_received) begin
    case (current_state)
      IDLE: begin
        output_bytes_reg <= 24'b0;
        done_reg <= 0;
      end
      WAIT_FOR_START: begin
        output_bytes_reg <= 24'b0;
        done_reg <= 0;
      end
      RECEIVE_BYTE1: begin
        output_bytes_reg <= {byte_buffer[2], byte_buffer[1], byte_buffer[0]};
        done_reg <= 0;
      end
      RECEIVE_BYTE2: begin
        output_bytes_reg <= {byte_buffer[2], byte_buffer[1], byte_buffer[0]};
        done_reg <= 0;
      end
      RECEIVE_BYTE3: begin
        output_bytes_reg <= {byte_buffer[2], byte_buffer[1], byte_buffer[0]};
        done_reg <= 1;
      end
    endcase
  end

  // Assignments
  assign out_bytes = output_bytes_reg;
  assign done = done_reg;

endmodule
