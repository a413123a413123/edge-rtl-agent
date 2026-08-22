module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Sequential logic
  reg [1:0] state;

  // State transition logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // State A
    end else begin
      case (state)
        2'b00: begin
          if (!x) begin
            state <= 2'b00; // Stay in state A
          end else begin
            state <= 2'b01; // Transition to state B
          end
        end
        2'b01: begin
          if (!x) begin
            state <= 2'b01; // Stay in state B
          end else begin
            state <= 2'b00; // Transition to state A
          end
        end
      endcase
    end
  end

  // Combinational logic
  assign z = (state == 2'b00) ? 1'b0 : 1'b1;

endmodule
