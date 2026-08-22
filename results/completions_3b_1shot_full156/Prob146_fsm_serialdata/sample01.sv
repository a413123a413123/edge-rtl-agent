module TopModule
(
  input  logic clk,
  input  logic in,
  input  logic reset,
  output logic [7:0] out_byte,
  output logic done
);

  // State definitions
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;

  // State register
  reg [1:0] state;

  // Data register
  reg [7:0] data;

  // Counter for data bits
  reg [3:0] data_count;

  // Next state logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      data <= 8'b0;
      data_count <= 4'b0;
      out_byte <= 8'b0;
      done <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (in) begin
            state <= START;
          end
        end
        START: begin
          if (in) begin
            state <= DATA;
          end
        end
        DATA: begin
          if (data_count < 8) begin
            data <= {data[7:1], in};
            data_count <= data_count + 1;
          end else begin
            state <= STOP;
          end
        end
        STOP: begin
          if (in) begin
            if (in == 1'b1) begin
              out_byte <= data;
              done <= 1;
              state <= IDLE;
            end else begin
              state <= STOP;
            end
          end
        end
      endcase
    end
  end

endmodule
