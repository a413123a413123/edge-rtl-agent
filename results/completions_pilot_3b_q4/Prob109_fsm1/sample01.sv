module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // Internal states
  logic state;

  // Initial state
  initial state = 'b1;

  // Moore machine logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state = 'b1;
    end else begin
      if (in) begin
        state = 'b1;
      end else begin
        state = 'b0;
      end
    end
  end

  // Output assignment
  assign out = state;

endmodule
