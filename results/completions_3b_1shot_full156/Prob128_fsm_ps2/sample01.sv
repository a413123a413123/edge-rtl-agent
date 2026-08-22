module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [7:0] in,
  output logic done
);

  // State definitions
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA1 = 2'b10;
  localparam DATA2 = 2'b11;

  // State register
  reg [1:0] state;

  // Byte counter
  reg [2:0] byte_count;

  // Done flag
  reg done_flag;

  // State machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      byte_count <= 0;
      done_flag <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (in[3]) begin
            state <= START;
            byte_count <= 0;
          end
        end
        START: begin
          if (byte_count == 2) begin
            state <= DATA1;
            byte_count <= 0;
          end else begin
            byte_count <= byte_count + 1;
          end
        end
        DATA1: begin
          if (byte_count == 1) begin
            state <= DATA2;
            byte_count <= 0;
          end else begin
            byte_count <= byte_count + 1;
          end
        end
        DATA2: begin
          if (byte_count == 0) begin
            state <= IDLE;
            done_flag <= 1;
          end else begin
            byte_count <= byte_count + 1;
          end
        end
      endcase
    end
  end

  // Output the done flag
  assign done = done_flag;

endmodule
