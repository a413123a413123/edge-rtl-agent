module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // States
  parameter S_A = 1'b0;
  parameter S_B = 1'b1;

  // Registers
  logic [0:0] current_state;

  // Initial state
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= S_B;
    end else begin
      current_state <= current_state;
    end
  end

  // State machine
  always_comb begin
    case (current_state)
      S_A: out = in;
      S_B: out = in;
    endcase
  end

endmodule
