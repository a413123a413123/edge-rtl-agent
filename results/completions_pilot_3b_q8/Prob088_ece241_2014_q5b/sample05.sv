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
    end else begin
      case (state)
        2'b00: begin
          if (x) begin
            state <= 2'b01;
          end else begin
            state <= 2'b00;
          end
        end
        2'b01: begin
          if (x) begin
            state <= 2'b00;
          end else begin
            state <= 2'b10;
          end
        end
        2'b10: begin
          if (x) begin
            state <= 2'b00;
          end else begin
            state <= 2'b10;
          end
        end
      endcase
    end
  end

  // Combinational logic
  assign z = state[0];

endmodule
