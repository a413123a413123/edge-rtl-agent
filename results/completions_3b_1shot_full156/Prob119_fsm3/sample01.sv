module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // State variables
  logic [1:0] state;

  // State transition table
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // State A
    end else begin
      case (state)
        2'b00: begin
          if (in) begin
            state <= 2'b01; // State B
          end else begin
            state <= 2'b00; // State A
          end
        end
        2'b01: begin
          if (in) begin
            state <= 2'b10; // State C
          end else begin
            state <= 2'b01; // State B
          end
        end
        2'b10: begin
          if (in) begin
            state <= 2'b00; // State A
          end else begin
            state <= 2'b11; // State D
          end
        end
        2'b11: begin
          if (in) begin
            state <= 2'b01; // State B
          end else begin
            state <= 2'b10; // State C
          end
        end
      endcase
    end
  end

  // Output logic
  assign out = (state == 2'b11);

endmodule
