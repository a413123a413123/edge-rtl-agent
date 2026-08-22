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
  reg [1:0] state;

  // Output signals
  assign disc = (state == ONE) && (in == 1'b0);
  assign flag = (state == THREE) && (in == 1'b0);
  assign err = (state == THREE) && (in == 1'b1);

  // State machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (in == 1'b1) begin
            state <= ONE;
          end
        end
        ONE: begin
          if (in == 1'b1) begin
            state <= TWO;
          end else begin
            state <= IDLE;
          end
        end
        TWO: begin
          if (in == 1'b1) begin
            state <= THREE;
          end else begin
            state <= ONE;
          end
        end
        THREE: begin
          if (in == 1'b1) begin
            state <= THREE;
          end else begin
            state <= IDLE;
          end
        end
      endcase
    end
  end

endmodule
