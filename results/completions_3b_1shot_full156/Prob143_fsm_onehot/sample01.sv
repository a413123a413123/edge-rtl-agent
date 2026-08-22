module TopModule
(
  input  logic in,
  input  logic [9:0] state,
  output logic [9:0] next_state,
  output logic out1,
  output logic out2
);

  // State transition logic
  always_comb begin
    case (state)
      10'b0000000000: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000000001: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000000010: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000000011: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000000100: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000000101: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000000110: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000000111: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001000: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001001: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001010: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001011: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001100: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001101: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001110: next_state = in ? 10'b0000010100 : 10'b0000000000;
      10'b0000001111: next_state = in ? 10'b0000010100 : 10'b0000000000;
      default: next_state = 10'b0000000000;
    endcase
  end

  // Output logic
  always_comb begin
    out1 = (state & 10'b0000000001) ? 1 : 0;
    out2 = (state & 10'b0000000010) ? 1 : 0;
  end

endmodule
