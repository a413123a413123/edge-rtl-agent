module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // States
  localparam A = 0;
  localparam B = 1;

  // Registers
  logic state;

  // Initial state
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= B;
    end else begin
      case (state)
        A: begin
          if (in) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          if (in) begin
            state <= A;
          end else begin
            state <= B;
          end
        end
      endcase
    end
  end

  // Output
  always_comb begin
    out = (state == B);
  end

endmodule
