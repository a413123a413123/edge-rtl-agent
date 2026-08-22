module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic out
);

  // State variables
  logic [0:0] state;

  // Initial state
  initial state = 2'b10;

  // State machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b10;
    end else begin
      case (state)
        2'b10: begin
          if (in == 0) begin
            state <= 2'b00;
          end else begin
            state <= 2'b10;
          end
        end
        2'b00: begin
          if (in == 0) begin
            state <= 2'b10;
          end else begin
            state <= 2'b00;
          end
        end
      endcase
    end
  end

  // Output assignment
  assign out = state[0];

endmodule
