module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // State register
  logic [1:0] state;

  // Next state logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // Reset into state A
    end else begin
      case (state)
        2'b00: begin
          if (x == 0) begin
            state <= 2'b00; // Stay in state A
          end else begin
            state <= 2'b01; // Move to state B
          end
        end
        2'b01: begin
          if (x == 0) begin
            state <= 2'b01; // Stay in state B
          end else begin
            state <= 2'b10; // Move to state B
          end
        end
        2'b10: begin
          if (x == 0) begin
            state <= 2'b10; // Stay in state B
          end else begin
            state <= 2'b01; // Move to state B
          end
        end
      endcase
    end
  end

  // Output logic
  always_comb begin
    case (state)
      2'b00: z = 0;
      2'b01: z = 1;
      2'b10: z = 1;
    endcase
  end

endmodule
