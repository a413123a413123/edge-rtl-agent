module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  logic next_state;
  logic current_state;

  // State Register
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= 'b1; // State B
    end else begin
      current_state <= next_state;
    end
  end

  // State Logic
  always_comb begin
    next_state = current_state;

    case (current_state)
      'b1: begin
        if (in) next_state = 'b1; // B (1) --1--> B
        else next_state = 'b0; // B (1) --0--> A
      end
      'b0: begin
        if (in) next_state = 'b0; // A (0) --1--> A
        else next_state = 'b1; // A (0) --0--> B
      end
    endcase
  end

  // Output Logic
  assign out = current_state;

endmodule
