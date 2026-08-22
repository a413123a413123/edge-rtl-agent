module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic j,
  input  logic k,
  output logic out
);

  // State variables
  logic [0:0] state;

  // Initial state
  initial state = 2'b00;

  // State machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
      out <= 2'b00;
    end else begin
      case (state)
        2'b00: begin
          if (j) begin
            state <= 2'b01;
          end
        end
        2'b01: begin
          if (k) begin
            state <= 2'b00;
          end
        end
      endcase
      out <= state;
    end
  end

endmodule
