[BEGIN]
module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic w,
  output logic z
);

  // State variables
  logic [1:0] state;

  // Initial state
  initial state = 2'b00;

  // State machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
      z <= 1'b0;
    end else begin
      case (state)
        2'b00: begin
          if (w) begin
            state <= 2'b01;
          end else begin
            state <= 2'b00;
          end
        end
        2'b01: begin
          if (w) begin
            state <= 2'b01;
          end else begin
            state <= 2'b00;
          end
        end
        2'b10: begin
          if (w) begin
            state <= 2'b11;
          end else begin
            state <= 2'b10;
          end
        end
        2'b11: begin
          if (w) begin
            state <= 2'b11;
          end else begin
            state <= 2'b10;
          end
        end
        2'b010: begin
          if (w) begin
            state <= 2'b011;
          end else begin
            state <= 2'b010;
          end
        end
        2'b011: begin
          if (w) begin
            state <= 2'b011;
          end else begin
            state <= 2'b010;
          end
        end
        2'b100: begin
          if (w) begin
            state <= 2'b101;
          end else begin
            state <= 2'b100;
          end
        end
        2'b101: begin
          if (w) begin
            state <= 2'b101;
          end else begin
            state <= 2'b100;
          end
        end
        2'b0100: begin
          if (w) begin
            state <= 2'b0101;
          end else begin
            state <= 2'b0100;
          end
        end
        2'b0101: begin
          if (w) begin
            state <= 2'b0101;
          end else begin
            state <= 2'b0100;
          end
        end
        2'b1000: begin
          if (w) begin
            state <= 2'b1001;
          end else begin
            state <= 2'b1000;
          end
        end
        2'b1001: begin
          if (w) begin
            state <= 2'b1001;
          end else begin
            state <= 2'b1000;
          end
        end
        2'b01000: begin
          if (w) begin
            state <= 2'b01001;
          end else begin
            state <= 2'b01000;
          end
        end
        2'b01001: begin
          if (w) begin
            state <= 2'b01001;
          end else begin
            state <= 2'b01000;
          end
        end
        2'b10000: begin
          if (w) begin
            state <= 2'b10001;
          end else begin
            state <= 2'b10000;
          end
        end
        2'b10001: begin
          if (w) begin
            state <= 2'b10001;
          end else begin
            state <= 2'b10000;
          end
        end
        2'b010000: begin
          if (w) begin
            state <= 2'b010001;
          end else begin
            state <= 2'b010000;
          end
        end
        2'b010001: begin
          if (w) begin
            state <= 2'b010001;
          end else begin
            state <= 2'b010000;
          end
        end
        2'b1
