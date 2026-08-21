module TopModule (
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // State encoding
  localparam STATE_A = 2'b00;
  localparam STATE_B = 2'b01;

  // State register
  logic [1:0] state;

  // Next state logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= STATE_A;
    end else begin
      case (state)
        STATE_A: begin
          if (x) begin
            state <= STATE_B;
          end else begin
            state <= STATE_A;
          end
        end
        STATE_B: begin
          if (x) begin
            state <= STATE_B;
          end else begin
            state <= STATE_A;
          end
        end
      endcase
    end
  end

  // Output logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      z <= 1'b0;
    end else begin
      case (state)
        STATE_A: begin
          z <= 1'b0;
        end
        STATE_B: begin
          z <= 1'b1;
        end
      endcase
    end
  end

endmodule
