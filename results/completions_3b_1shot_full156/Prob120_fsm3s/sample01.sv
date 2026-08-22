module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic out
);

  // State variables
  logic [1:0] state;

  // State transition table
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // State A
    end else begin
      case (state)
        2'b00: begin
          if (in) begin
            state <= 2'b01; // Next state B
          end else begin
            state <= 2'b00; // Stay in state A
          end
        end
        2'b01: begin
          if (in) begin
            state <= 2'b10; // Next state C
          end else begin
            state <= 2'b01; // Stay in state B
          end
        end
        2'b10: begin
          if (in) begin
            state <= 2'b00; // Next state A
          end else begin
            state <= 2'b10; // Stay in state C
          end
        end
        2'b11: begin
          if (in) begin
            state <= 2'b01; // Next state B
          end else begin
            state <= 2'b11; // Stay in state D
          end
        end
      endcase
    end
  end

  // Output logic
  assign out = (state == 2'b11);

endmodule
