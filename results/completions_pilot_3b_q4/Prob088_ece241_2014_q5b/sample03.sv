module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Registers
  reg [1:0] state;

  // Combinational logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00;
    end else begin
      case (state)
        2'b00: begin
          if (!x) begin
            state <= 2'b00;
          end else begin
            state <= 2'b01;
          end
        end
        2'b01: begin
          if (!x) begin
            state <= 2'b01;
          end else begin
            state <= 2'b10;
          end
        end
        2'b10: begin
          if (!x) begin
            state <= 2'b10;
          end else begin
            state <= 2'b00;
          end
        end
      endcase
    end
  end

  // Sequential logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      z <= 1'b0;
    end else begin
      case (state)
        2'b00: begin
          z <= 1'b0;
        end
        2'b01: begin
          z <= 1'b1;
        end
        2'b10: begin
          z <= 1'b1;
        end
      endcase
    end
  end

endmodule
