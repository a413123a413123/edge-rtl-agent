module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Declare state variables
  logic [1:0] state;

  // Initial state
  always_ff @(posedge clk) begin
    if (areset) begin
      state <= 2'b00;
    end
  end

  // Mealy finite-state machine
  always_ff @(posedge clk) begin
    case (state)
      2'b00: begin
        if (x == 1'b0) begin
          state <= 2'b00;
          z <= 1'b0;
        end else begin
          state <= 2'b01;
          z <= 1'b1;
        end
      end
      2'b01: begin
        if (x == 1'b0) begin
          state <= 2'b01;
          z <= 1'b1;
        end else begin
          state <= 2'b10;
          z <= 1'b0;
        end
      end
      2'b10: begin
        if (x == 1'b0) begin
          state <= 2'b10;
          z <= 1'b0;
        end else begin
          state <= 2'b11;
          z <= 1'b1;
        end
      end
      2'b11: begin
        if (x == 1'b0) begin
          state <= 2'b11;
          z <= 1'b1;
        end else begin
          state <= 2'b00;
          z <= 1'b0;
        end
      end
    endcase
  end

endmodule
