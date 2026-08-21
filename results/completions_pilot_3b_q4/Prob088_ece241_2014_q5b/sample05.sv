module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Register for the state
  logic [1:0] state_reg;

  // Next state logic
  always_ff @(posedge clk or posedge areset)
  begin
    if (areset) begin
      state_reg <= 2'b00;
    end else begin
      case (state_reg)
        2'b00: state_reg <= x ? 2'b01 : 2'b00;
        2'b01: state_reg <= x ? 2'b11 : 2'b01;
        default: state_reg <= 2'b01;
      endcase
    end
  end

  // Output logic
  always_comb
  begin
    z = state_reg[1];
  end

endmodule
