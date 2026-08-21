module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  // State definitions
  localparam IDLE = 2'b00;
  localparam ONE = 2'b01;
  localparam TWO = 2'b10;
  localparam THREE = 2'b11;

  // State variables
  logic [1:0] current_state = IDLE;
  logic [4:0] sequence_counter = 0;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
      sequence_counter <= 0;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      case (current_state)
        IDLE: begin
          if (in) begin
            current_state <= ONE;
            sequence_counter <= 1;
          end else begin
            current_state <= IDLE;
            sequence_counter <= 0;
          end
        end
        ONE: begin
          if (in) begin
            sequence_counter <= sequence_counter + 1;
            if (sequence_counter == 5) begin
              current_state <= TWO;
              sequence_counter <= 0;
            end
          end else begin
            current_state <= IDLE;
            sequence_counter <= 0;
          end
        end
        TWO: begin
          if (in) begin
            sequence_counter <= sequence_counter + 1;
            if (sequence_counter == 5) begin
              current_state <= THREE;
              sequence_counter <= 0;
            end
          end else begin
            current_state <= ONE;
            sequence_counter <= 0;
          end
        end
        THREE: begin
          if (in) begin
            sequence_counter <= sequence_counter + 1;
            if (sequence_counter == 5) begin
              current_state <= IDLE;
              sequence_counter <= 0;
              disc <= 1'b1;
            end else if (sequence_counter == 6) begin
              current_state <= IDLE;
              sequence_counter <= 0;
              flag <= 1'b1;
            end else if (sequence_counter == 7) begin
              current_state <= IDLE;
              sequence_counter <= 0;
              err <= 1'b1;
            end
          end else begin
            current_state <= TWO;
            sequence_counter <= 0;
          end
        end
      endcase
    end
  end

endmodule
