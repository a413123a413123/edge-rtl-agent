module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // States
  typedef enum logic [1:0] {A, B} state_t;
  state_t state;

  // Register for state
  logic [1:0] state_reg;

  // Output register
  logic z_reg;

  // State machine
  always @(posedge clk or posedge areset)
  begin
    if (areset)
      state_reg <= A;
    else
      state_reg <= state;

    case (state_reg)
      A: begin
          z_reg <= 0;
          if (x == 1'b1)
            state <= B;
        end
      B: begin
          z_reg <= 1;
          if (x == 1'b0)
            state <= A;
        end
    endcase
  end

  // Output register
  assign z = z_reg;

endmodule
