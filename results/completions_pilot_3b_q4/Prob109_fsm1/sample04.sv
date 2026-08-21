module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // Registers
  logic [0:0] state;

  // State machine
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 1'b1;
    end else begin
      case (state)
        1'b1: begin
          if (in == 1'b1) begin
            state <= 1'b1;
          end else begin
            state <= 1'b0;
          end
        end
        1'b0: begin
          if (in == 1'b0) begin
            state <= 1'b0;
          end else begin
            state <= 1'b1;
          end
        end
      endcase
    end
  end

  // Output
  assign out = state;

endmodule
