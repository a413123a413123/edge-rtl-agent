module TopModule
(
  input  logic clk,
  input  logic x,
  input  logic [2:0] y,
  output logic Y0,
  output logic z
);

  // State variables
  logic [2:0] next_state;

  // Next state logic
  always @(posedge clk) begin
    case (y)
      3'b000: next_state = x ? 3'b001 : 3'b000;
      3'b001: next_state = x ? 3'b100 : 3'b001;
      3'b010: next_state = x ? 3'b001 : 3'b010;
      3'b011: next_state = x ? 3'b010 : 3'b001;
      3'b100: next_state = x ? 3'b100 : 3'b011;
    endcase
  end

  // Output logic
  assign Y0 = next_state[0];
  assign z = next_state[2];

endmodule
