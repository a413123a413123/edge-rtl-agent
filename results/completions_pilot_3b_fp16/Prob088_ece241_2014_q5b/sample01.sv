module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Define states
  typedef enum { A, B } state_t;
  state_t state;

  // Register for current state
  reg state_reg;

  // Mealy machine logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_reg <= A;
    end else begin
      case (state_reg)
        A:
          if (x == 0) begin
            state_reg <= A;
          end else begin
            state_reg <= B;
          end
        B:
          if (x == 0) begin
            state_reg <= B;
          end else begin
            state_reg <= B;
          end
      endcase
    end
  end

  // Output logic
  assign z = (state_reg == A);

endmodule
