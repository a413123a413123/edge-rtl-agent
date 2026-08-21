module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Sequential logic

  reg [1:0] state;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00;
      z <= 1'b0;
    end else begin
      case (state)
        2'b00: begin
          if (x) begin
            state <= 2'b10;
          end else begin
            state <= 2'b00;
          end
          z <= state[1];
        end
        2'b10: begin
          if (x) begin
            state <= 2'b10;
          end else begin
            state <= 2'b00;
          end
          z <= state[1];
        end
      endcase
    end
  end

endmodule
